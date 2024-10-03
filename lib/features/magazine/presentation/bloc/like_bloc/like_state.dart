part of 'like_bloc.dart';

@immutable
sealed class LikeState {}

final class LikeInitial extends LikeState {}

final class LikeSuccessState extends LikeState {}

final class LikeFailureState extends LikeState {
  final String error;

  LikeFailureState({required this.error});
}

final class LikeUpdatedState extends LikeState {
  final List<String> likes;
  final String magazineId;
  LikeUpdatedState(this.magazineId, {required this.likes});
}
