import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:magspot/core/error/exceptions.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/features/magazine/data/datasources/remote_data_source.dart';
import 'package:magspot/features/magazine/data/models/magazine_model.dart';
import 'package:magspot/features/magazine/domain/entities/magazine.dart';
import 'package:magspot/features/magazine/domain/repository/magazine_repository.dart';
import 'package:uuid/uuid.dart';

class MagazineRepositoryImpl implements MagazineRepository {
  final MagazineRemoteDataSource magazineRemoteDataSource;

  MagazineRepositoryImpl({required this.magazineRemoteDataSource});
  @override
  Future<Either<Failure, Magazine>> uploadMagazine(
      {required File pdf,
      required String name,
      required String authorName,
      required String description,
      required String posterId}) async {
    try {
      MagazineModel magazineModel = MagazineModel(
          id: const Uuid().v1(),
          name: name,
          authorName: authorName,
          description: description,
          file: '',
          posterId: posterId);
      final imageUrl = await magazineRemoteDataSource.uploadMagazinePdf(
          file: pdf, magazineModel: magazineModel);
      magazineModel.copyWith(file: imageUrl);
      final magData =
          await magazineRemoteDataSource.uploadMagazine(magazineModel);
      return right(magData);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
