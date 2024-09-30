import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/features/magazine/domain/usecases/like_magazine.dart';
import 'package:magspot/features/magazine/domain/usecases/subscribe_to_likes.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final LikeMagazineUseCase _likeMagazineUseCase;
  final SubscribeToLikes _subscribeToLikes;

  LikeBloc({
    required LikeMagazineUseCase likeMagazineUsecase,
    required SubscribeToLikes subscribeToLikes,
  })  : _likeMagazineUseCase = likeMagazineUsecase,
        _subscribeToLikes = subscribeToLikes,
        super(LikeInitial()) {
    on<LikeMagazineEvent>(_onLikeMagazine);
    on<SubscribeToLikesEvent>(_onSubscribeToLikes);
  }

  FutureOr<void> _onLikeMagazine(
      LikeMagazineEvent event, Emitter<LikeState> emit) async {
    final res = await _likeMagazineUseCase(
        LikeMagazineParams(magazineId: event.magazineId, userId: event.userId));
    res.fold(
      (l) => emit(LikeFailureState(error: l.message)),
      (r) {
        // After liking the magazine, subscribe to the likes stream
        add(SubscribeToLikesEvent(magazineId: event.magazineId));
      },
    );
  }

  FutureOr<void> _onSubscribeToLikes(
      SubscribeToLikesEvent event, Emitter<LikeState> emit) async {
    print('Subscribing to likes for magazine ID: ${event.magazineId}');

    final likeStreamResult =
        await _subscribeToLikes(LikeParams(magazineId: event.magazineId));

    await likeStreamResult.fold(
      (failure) {
        print('Failed to subscribe to likes: ${failure.message}');
        emit(LikeFailureState(error: failure.message));
      },
      (likesStream) async {
        // Fix: Await the emit.forEach to handle the stream properly within the Bloc lifecycle
        await emit.forEach<List<String>>(
          likesStream,
          onData: (likes) {
            print('New likes received: $likes'); // Log the likes

            // Emit the updated state with the latest likes
            return LikeUpdatedState(
              likes: List.from(likes),
            );
          },
          onError: (_, __) {
            return LikeFailureState(error: 'Failed to listen for likes.');
          },
        );
      },
    );
  }

  @override
  Future<void> close() {
    print('Closing LikeBloc');
    return super.close();
  }
}
