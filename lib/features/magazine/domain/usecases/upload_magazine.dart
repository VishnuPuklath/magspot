import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/core/usecase/usecase.dart';
import 'package:magspot/features/magazine/domain/entities/magazine.dart';
import 'package:magspot/features/magazine/domain/repository/magazine_repository.dart';

class UploadMagazine implements Usecase<Magazine, UploadMagParams> {
  final MagazineRepository magazineRepository;

  UploadMagazine({required this.magazineRepository});
  @override
  Future<Either<Failure, Magazine>> call(params) async {
    print('usecase executed');
    return await magazineRepository.uploadMagazine(
      thumbnail: params.thumbnail,
      pdf: params.file,
      name: params.name,
      authorName: params.authorname,
      description: params.description,
      posterId: params.posterId,
    );
  }
}

class UploadMagParams {
  final String posterId;
  final String name;
  final String authorname;
  final String description;
  final File file;
  final File thumbnail;

  UploadMagParams(
      {required this.posterId,
      required this.thumbnail,
      required this.name,
      required this.authorname,
      required this.description,
      required this.file});
}
