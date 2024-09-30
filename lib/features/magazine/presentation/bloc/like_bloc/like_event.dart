part of 'like_bloc.dart';

@immutable
sealed class LikeEvent {}

class LikeMagazineEvent extends LikeEvent {
  final String magazineId;
  final String userId;

  LikeMagazineEvent({required this.magazineId, required this.userId});
}

final class SubscribeToLikesEvent extends LikeEvent {
  final String magazineId;

  SubscribeToLikesEvent({required this.magazineId});
}
