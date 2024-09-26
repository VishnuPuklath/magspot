class CommentModel {
  final String id;
  final String content;

  CommentModel({
    required this.id,
    required this.content,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
    };
  }
}
