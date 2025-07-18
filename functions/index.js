// functions/index.js

const { onDocumentUpdated, onDocumentCreated, onDocumentDeleted } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

/**
 * Bir kullanıcının 'following' listesi güncellendiğinde tetiklenir.
 * Bu fonksiyon, takip edilen/bırakılan kullanıcının 'followers' listesini günceller.
 * YAZIM ŞEKLİ YENİ v2 SYNTAX'INA GÜNCELLENDİ.
 */
exports.onUserFollow = onDocumentUpdated("users/{userId}", async (event) => {
  // event objesinden önceki ve sonraki veriyi al
  const afterData = event.data.after.data();
  const beforeData = event.data.before.data();
  // event objesinden parametreleri al
  const userId = event.params.userId;

  const db = getFirestore();

  const newFollowing = afterData.following || [];
  const oldFollowing = beforeData.following || [];

  if (newFollowing.length === oldFollowing.length) {
    console.log(`No change in following for user ${userId}. Exiting function.`);
    return null;
  }

  const followedUsers = newFollowing.filter((u) => !oldFollowing.includes(u));
  const unfollowedUsers = oldFollowing.filter((u) => !newFollowing.includes(u));

  const batch = db.batch();

  if (followedUsers.length > 0) {
    console.log(`User ${userId} started following: ${followedUsers.join(", ")}`);
    followedUsers.forEach((followedId) => {
      const docRef = db.collection("users").doc(followedId);
      batch.update(docRef, { followers: FieldValue.arrayUnion(userId) });
    });
  }

  if (unfollowedUsers.length > 0) {
    console.log(`User ${userId} unfollowed: ${unfollowedUsers.join(", ")}`);
    unfollowedUsers.forEach((unfollowedId) => {
      const docRef = db.collection("users").doc(unfollowedId);
      batch.update(docRef, { followers: FieldValue.arrayRemove(userId) });
    });
  }

  // Toplu işlemi gerçekleştir
  return batch.commit();
});

// --- YENİ FONKSİYON 1: YENİ GÖNDERİ OLUŞTURULDUĞUNDA DAĞITMA ---
exports.onPostCreated = onDocumentCreated("posts/{postId}", async (event) => {
  const postData = event.data.data();
  const postId = event.params.postId;
  const authorId = postData.authorId;

  console.log(`[onPostCreated] Function triggered for post: ${postId} by author: ${authorId}`);

  const db = getFirestore();

  try {
    // Gönderiyi yapan kullanıcının takipçilerini bul
    const followersSnapshot = await db.collection("users")
        .where("following", "array-contains", authorId)
        .get();

    // BULUNAN TAKİPÇİ SAYISINI LOGLA
    console.log(`[onPostCreated] Found ${followersSnapshot.size} followers for author ${authorId}.`);

    if (followersSnapshot.empty) {
      console.log("[onPostCreated] Author has no followers. Fanning out only to the author.");
    }

    const batch = db.batch();

    // Her bir takipçinin feed'ine bu yeni gönderiyi ekle
    followersSnapshot.forEach((doc) => {
      const followerId = doc.id;
      // HANGİ TAKİPÇİYE YAZILDIĞINI LOGLA
      console.log(`[onPostCreated] Fanning out post ${postId} to follower: ${followerId}`);
      const followerFeedRef = db.doc(`feeds/${followerId}/user_feed_items/${postId}`);
      batch.set(followerFeedRef, postData);
    });

    // Yazarın kendi feed'ine de gönderiyi ekle
    console.log(`[onPostCreated] Fanning out post ${postId} to author's own feed: ${authorId}`);
    const authorFeedRef = db.doc(`feeds/${authorId}/user_feed_items/${postId}`);
    batch.set(authorFeedRef, postData);

    await batch.commit();
    console.log("[onPostCreated] Batch commit successful.");
    return null;

  } catch (error) {
    // HATA OLURSA LOGLA
    console.error(`[onPostCreated] Error fanning out post ${postId}:`, error);
    return null;
  }
});


// --- YENİ FONKSİYON 2: GÖNDERİ SİLİNDİĞİNDE FEED'LERDEN TEMİZLEME ---
exports.onPostDeleted = onDocumentDeleted("posts/{postId}", async (event) => {
  const deletedPost = event.data.data();
  const postId = event.params.postId;
  const authorId = deletedPost.authorId;

  console.log(`Post ${postId} by ${authorId} was deleted. Fanning-in delete.`);

  // Gönderiyi yapan kullanıcının takipçilerini bul
  const followersSnapshot = await db.collection("users")
      .where("following", "array-contains", authorId)
      .get();

  const batch = db.batch();

  // Her bir takipçinin feed'inden bu gönderiyi sil
  followersSnapshot.forEach((doc) => {
    const followerId = doc.id;
    const followerFeedRef = db.doc(`feeds/${followerId}/user_feed_items/${postId}`);
    batch.delete(followerFeedRef);
  });

  // Yazarın kendi feed'inden de gönderiyi sil
  const authorFeedRef = db.doc(`feeds/${authorId}/user_feed_items/${postId}`);
  batch.delete(authorFeedRef);

  // Toplu silme işlemini gerçekleştir
  return batch.commit();
});