class Comment {
  final String id;
  final String magazineId;
  final String userId;
  final String userName;
  final String commentText;
  final DateTime createdAt;

  Comment(
      {required this.id,
      required this.magazineId,
      required this.userId,
      required this.userName,
      required this.commentText,
      required this.createdAt});
}
