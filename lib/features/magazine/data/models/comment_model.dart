// data/models/comment_model.dart
import 'package:magspot/features/magazine/domain/entities/comment.dart';

class CommentModel extends Comment {
  CommentModel({
    required String id,
    required String magazineId,
    required String userId,
    required String userName,
    required String commentText,
    required DateTime createdAt,
  }) : super(
          id: id,
          magazineId: magazineId,
          userId: userId,
          userName: userName,
          commentText: commentText,
          createdAt: createdAt,
        );

  // Factory constructor to create CommentModel from JSON
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      magazineId: json['magazine_id'] as String,
      userId: json['user_id'] as String,
      userName: json['profiles']['name'] as String, // Assuming profile join
      commentText: json['comment_text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Method to convert CommentModel to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'magazine_id': magazineId,
      'user_id': userId,
      'comment_text': commentText,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
