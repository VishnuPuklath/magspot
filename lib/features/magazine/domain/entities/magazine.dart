import 'package:magspot/features/magazine/domain/entities/comment.dart';

class Magazine {
  final String id;
  final String name;
  final String authorname;
  final String description;
  final String file;
  final String thumbnail;
  final String posterId;
  final String? posterName;
  final List<String>? likes;
  List<Comment>? comments;
  Magazine({
    this.likes,
    this.comments,
    required this.thumbnail,
    required this.id,
    required this.name,
    required this.posterId,
    required this.authorname,
    required this.description,
    required this.file,
    this.posterName,
  });
}
