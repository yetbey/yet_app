// functions/index.js

// v2 için gerekli importlar
const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");

// Admin SDK'yı başlat
initializeApp();

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