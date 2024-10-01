import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/features/magazine/domain/entities/comment.dart';
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
  Stream<Either<Failure, List<String>>> subscribeToLikes(
      {required String magazineId});
  Future<Either<Failure, void>> addComment({
    required String magazineId,
    required String userId,
    required String commentText,
  });
  Future<Either<Failure, List<Comment>>> getComments(String magazineId);
}
