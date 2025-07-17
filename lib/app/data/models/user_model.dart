import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String displayName;
  final String email;
  final String? profilePhotoUrl;
  final String bio;
  final List followers;
  final List following;

  UserModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    this.profilePhotoUrl,
    required this.bio,
    required this.followers,
    required this.following,
  });

  factory UserModel.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      username: map['username'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      profilePhotoUrl: map['profilePhotoUrl'],
      bio: map['bio'] ?? '',
      followers: List.from(map['followers'] ?? []),
      following: List.from(map['following'] ?? []),
    );
  }
}
