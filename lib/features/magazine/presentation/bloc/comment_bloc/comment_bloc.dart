import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/features/magazine/domain/entities/comment.dart';
import 'package:magspot/features/magazine/domain/usecases/add_comment.dart';
import 'package:magspot/features/magazine/domain/usecases/get_comments.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final AddCommentUsecase _addCommentUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  CommentBloc(
      {required AddCommentUsecase addCommentUseCase,
      required GetCommentsUseCase getCommentUseCase})
      : _addCommentUseCase = addCommentUseCase,
        _getCommentsUseCase = getCommentUseCase,
        super(CommentInitial()) {
    on<CommentEvent>((event, emit) {});
    on<AddCommentEvent>(_onAddComment);
    on<GetCommentsEvent>(_onGetComments);
  }

  Future<void> _onAddComment(
      AddCommentEvent event, Emitter<CommentState> emit) async {
    final res = await _addCommentUseCase(AddCommentParams(
      magazineId: event.magazineId,
      userId: event.userId,
      commentText: event.commentText,
    ));
    res.fold(
      (failure) => emit(CommentError(failure.message)),
      (_) => add(
        GetCommentsEvent(event.magazineId),
      ),
    );
  }

  Future<void> _onGetComments(
    GetCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentsLoading());
    final res = await _getCommentsUseCase(event.magazineId);
    res.fold(
      (failure) => emit(CommentError(failure.message)),
      (comments) => emit(CommentsLoaded(comments: comments)),
    );
  }
}
