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
  // Yeni oluşturulan gönderinin verisini ve ID'sini al
  const postData = event.data.data();
  const postId = event.params.postId;
  const authorId = postData.authorId;

  console.log(`New post ${postId} created by ${authorId}. Fanning out.`);

  // Gönderiyi yapan kullanıcının takipçilerini bul
  const followersSnapshot = await db.collection("users")
      .where("following", "array-contains", authorId)
      .get();

  if (followersSnapshot.empty) {
    console.log("Author has no followers, no need to fan-out.");
  }

  // Her bir takipçinin feed'ine bu yeni gönderiyi ekle
  const batch = db.batch();
  followersSnapshot.forEach((doc) => {
    const followerId = doc.id;
    const followerFeedRef = db.doc(`feeds/${followerId}/user_feed_items/${postId}`);
    batch.set(followerFeedRef, postData);
  });

  // Yazarın kendi feed'ine de gönderiyi ekle
  const authorFeedRef = db.doc(`feeds/${authorId}/user_feed_items/${postId}`);
  batch.set(authorFeedRef, postData);

  // Toplu yazma işlemini gerçekleştir
  return batch.commit();
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