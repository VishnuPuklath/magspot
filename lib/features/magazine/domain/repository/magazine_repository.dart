import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/features/magazine/domain/entities/magazine.dart';

abstract interface class MagazineRepository {
  Future<Either<Failure, Magazine>> uploadMagazine({
    required File thumbnail,
    required File pdf,
    required String name,
    required String authorName,
    required String description,
    required String posterId,
  });
  Future<Either<Failure, List<Magazine>>> getAllMagazine();
  Future<Either<Failure, void>> likeMagazine(
      {required String magazineId, required String userId});
  Future<Either<Failure, Stream<List<String>>>> subscribeToLikes(
      {required String magazineId});
}
