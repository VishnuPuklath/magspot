import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/features/magazine/domain/entities/magazine.dart';
import 'package:magspot/features/magazine/domain/usecases/upload_magazine.dart';

part 'mag_bloc_event.dart';
part 'mag_bloc_state.dart';

class MagBlocBloc extends Bloc<MagBlocEvent, MagBlocState> {
  final UploadMagazine uploadMagazine;
  MagBlocBloc(this.uploadMagazine) : super(MagBlocInitial()) {
    on<MagBlocEvent>((event, emit) => emit(MagBlocLoading()));
    on<MagazineUpload>(_onMagazineUpload);
  }

  void _onMagazineUpload(
      MagazineUpload event, Emitter<MagBlocState> emit) async {
    final res = await uploadMagazine(UploadMagParams(
        posterId: event.posterId,
        name: event.name,
        authorname: event.authorname,
        description: event.description,
        file: event.file));
    res.fold(
      (l) => MagBlocFailure(l.message),
      (r) => MagBlocSuccess(magazine: r),
    );
  }
}
