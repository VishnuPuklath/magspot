part of 'comment_bloc.dart';

@immutable
sealed class CommentEvent {}

class AddCommentEvent extends CommentEvent {
  final String magazineId;
  final String userId;
  final String commentText;

  AddCommentEvent({
    required this.magazineId,
    required this.userId,
    required this.commentText,
  });
}

class GetCommentsEvent extends CommentEvent {
  final String magazineId;

  GetCommentsEvent(this.magazineId);
}

class LoadInitialCommentCountEvent extends CommentEvent {
  final String magazineId;

  LoadInitialCommentCountEvent(this.magazineId);
}
