import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/usecase/usecase.dart';
import 'package:magspot/features/magazine/domain/entities/magazine.dart';
import 'package:magspot/features/magazine/domain/usecases/get_all_magazine.dart';
import 'package:magspot/features/magazine/domain/usecases/like_magazine.dart';
import 'package:magspot/features/magazine/domain/usecases/upload_magazine.dart';

part 'mag_bloc_event.dart';
part 'mag_bloc_state.dart';

class MagBlocBloc extends Bloc<MagBlocEvent, MagBlocState> {
  final UploadMagazine _uploadMagazine;

  final GetAllMagazine _getAllMagazine;

  MagBlocBloc({
    required UploadMagazine uploadMagazine,
    required LikeMagazineUseCase likeMagazineUsecase,
    required GetAllMagazine getAllMagazine,
  })  : _uploadMagazine = uploadMagazine,
        _getAllMagazine = getAllMagazine,
        super(MagBlocInitial()) {
    on<MagazineUpload>(_onMagazineUpload);
    on<MagazineGetAllEvent>(_onFetchAllMagazine);
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
}
