class Comment {
  final String id;
  final String magazineId;
  final String userId;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.magazineId,
    required this.userId,
    required this.content,
    required this.timestamp,
  });
}
