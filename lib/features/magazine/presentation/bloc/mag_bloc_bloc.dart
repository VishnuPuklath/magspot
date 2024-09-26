import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/usecase/usecase.dart';
import 'package:magspot/features/magazine/domain/entities/magazine.dart';
import 'package:magspot/features/magazine/domain/usecases/get_all_magazine.dart';
import 'package:magspot/features/magazine/domain/usecases/like_magazine.dart';
import 'package:magspot/features/magazine/domain/usecases/subscribe_to_likes.dart';
import 'package:magspot/features/magazine/domain/usecases/upload_magazine.dart';

part 'mag_bloc_event.dart';
part 'mag_bloc_state.dart';

class MagBlocBloc extends Bloc<MagBlocEvent, MagBlocState> {
  final UploadMagazine _uploadMagazine;
  final SubscribeToLikes _subscribeToLikes;
  final GetAllMagazine _getAllMagazine;
  final LikeMagazineUseCase _likeMagazineUseCase;
  StreamSubscription<List<String>>? _likesSubscription;

  MagBlocBloc({
    required UploadMagazine uploadMagazine,
    required SubscribeToLikes subscribeToLikes,
    required LikeMagazineUseCase likeMagazineUsecase,
    required GetAllMagazine getAllMagazine,
  })  : _uploadMagazine = uploadMagazine,
        _subscribeToLikes = subscribeToLikes,
        _getAllMagazine = getAllMagazine,
        _likeMagazineUseCase = likeMagazineUsecase,
        super(MagBlocInitial()) {
    on<MagazineUpload>(_onMagazineUpload);
    on<MagazineGetAllEvent>(_onFetchAllMagazine);
    on<LikeMagazine>(_onLikeMagazine);
    on<SubscribeToLikesEvent>(_onSubscribeToLikes);
  }

  void _onMagazineUpload(
      MagazineUpload event, Emitter<MagBlocState> emit) async {
    emit(MagBlocLoading()); // Emit loading only for specific event
    final res = await _uploadMagazine(
      UploadMagParams(
        thumbnail: event.thumbnail,
        posterId: event.posterId,
        name: event.name,
        authorname: event.authorname,
        description: event.description,
        file: event.file,
      ),
    );

    res.fold(
      (l) => emit(MagBlocFailure(l.message)),
      (r) => emit(MagBlocSuccess(magazine: r)),
    );
  }

  FutureOr<void> _onFetchAllMagazine(
      MagazineGetAllEvent event, Emitter<MagBlocState> emit) async {
    // Emit loading before fetching magazines
    final res = await _getAllMagazine(NoParams());
    res.fold(
      (l) => emit(MagBlocFailure(l.message)),
      (r) => emit(MagFetchAllSuccess(magazines: r)),
    );
  }

  FutureOr<void> _onLikeMagazine(
      LikeMagazine event, Emitter<MagBlocState> emit) async {
    final res = await _likeMagazineUseCase(
        LikeMagazineParams(magazineId: event.magazineId, userId: event.userId));
    res.fold(
      (l) => emit(MagBlocFailure(l.message)),
      (r) => add(MagazineGetAllEvent()),
    );
  }

  FutureOr<void> _onSubscribeToLikes(
      SubscribeToLikesEvent event, Emitter<MagBlocState> emit) async {
    final likeStreamResult =
        await _subscribeToLikes(LikeParams(magazineId: event.magazineId));

    if (!emit.isDone) {
      likeStreamResult.fold(
        (l) => emit(MagBlocFailure(l.message)),
        (likesStream) async {
          await _likesSubscription?.cancel();
          likesStream.listen(
            (likes) {
              if (!emit.isDone) {
                emit(MagazineLikesUpdated(likes: likes)); // Update likes only
              }
            },
          );
        },
      );
    }
  }

  @override
  Future<void> close() {
    _likesSubscription?.cancel();
    return super.close();
  }
}
