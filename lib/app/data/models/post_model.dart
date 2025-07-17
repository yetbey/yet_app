import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String authorId;
  final String? imageUrl;
  final String caption;
  final int likeCount;
  final Timestamp timestamp;

  final String authorUsername;
  final String? authorProfilePhotoUrl;

  PostModel({
    required this.id,
    required this.authorId,
    this.imageUrl,
    required this.caption,
    required this.likeCount,
    required this.timestamp,
    required this.authorUsername,
    this.authorProfilePhotoUrl,
  });

  factory PostModel.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      authorId: map['authorId'] ?? '',
      imageUrl: map['imageUrl'],
      caption: map['caption'] ?? '',
      likeCount: map['likeCount'] ?? 0,
      timestamp: map['timestamp'] ?? Timestamp.now(),
      authorUsername: map['authorUsername'] ?? 'bilinmeyen',
      authorProfilePhotoUrl: map['authorProfilePhotoUrl'],
    );
  }
}
