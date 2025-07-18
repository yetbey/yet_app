// functions/index.js

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

/**
 * Bir kullanıcının 'following' listesi güncellendiğinde tetiklenir.
 * Bu fonksiyon, takip edilen kullanıcının 'followers' listesini günceller.
 */
exports.onUserFollow = functions.firestore
    .document("users/{userId}")
    .onUpdate(async (change, context) => {
      const newData = change.after.data();
      const previousData = change.before.data();
      const userId = context.params.userId;

      const newFollowing = newData.following || [];
      const oldFollowing = previousData.following || [];

      // Takip edilen yeni kişileri bul (eski listede olmayıp yeni listede olanlar)
      const followedUsers = newFollowing.filter((u) => !oldFollowing.includes(u));
      // Takipten çıkılan kişileri bul (eski listede olup yeni listede olmayanlar)
      const unfollowedUsers = oldFollowing.filter((u) => !newFollowing.includes(u));

      const promises = [];

      // Takip edilen her kullanıcı için 'followers' listesini güncelle
      if (followedUsers.length > 0) {
        console.log(`User ${userId} started following: ${followedUsers.join(", ")}`);
        followedUsers.forEach((followedId) => {
          const promise = db.collection("users").doc(followedId).update({
            followers: admin.firestore.FieldValue.arrayUnion(userId),
          });
          promises.push(promise);
        });
      }

      // Takipten çıkılan her kullanıcı için 'followers' listesini güncelle
      if (unfollowedUsers.length > 0) {
        console.log(`User ${userId} unfollowed: ${unfollowedUsers.join(", ")}`);
        unfollowedUsers.forEach((unfollowedId) => {
          const promise = db.collection("users").doc(unfollowedId).update({
            followers: admin.firestore.FieldValue.arrayRemove(userId),
          });
          promises.push(promise);
        });
      }

      return Promise.all(promises);
    });