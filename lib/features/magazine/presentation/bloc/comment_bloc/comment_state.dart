part of 'comment_bloc.dart';

@immutable
sealed class CommentState {}

class CommentInitial extends CommentState {}

class CommentsLoading extends CommentState {}

class CommentsLoaded extends CommentState {
  final List<Comment> comments;

  CommentsLoaded({required this.comments});
}

class CommentError extends CommentState {
  final String message;

  CommentError(this.message);
}
