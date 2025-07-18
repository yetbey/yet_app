import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String text;
  final String authorId;
  final String authorUsername;
  final Timestamp timestamp;

  CommentModel({
    required this.id,
    required this.text,
    required this.authorId,
    required this.authorUsername,
    required this.timestamp,
});

  factory CommentModel.fromMap(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id: doc.id,
      text: map['text'] ?? '',
      authorId: map['authorId'] ?? '',
      authorUsername: map['authorUsername'] ?? 'bilinmeyen',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

}