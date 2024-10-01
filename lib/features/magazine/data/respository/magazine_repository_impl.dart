import 'dart:io';
import 'package:fpdart/src/either.dart';
import 'package:magspot/core/error/exceptions.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/features/magazine/data/datasources/remote_data_source.dart';
import 'package:magspot/features/magazine/data/models/magazine_model.dart';
import 'package:magspot/features/magazine/domain/entities/comment.dart';
import 'package:magspot/features/magazine/domain/entities/magazine.dart';
import 'package:magspot/features/magazine/domain/repository/magazine_repository.dart';
import 'package:uuid/uuid.dart';

class MagazineRepositoryImpl implements MagazineRepository {
  final MagazineRemoteDataSource magazineRemoteDataSource;

  MagazineRepositoryImpl({required this.magazineRemoteDataSource});
  @override
  Future<Either<Failure, Magazine>> uploadMagazine(
      {required File pdf,
      required File thumbnail,
      required String name,
      required String authorName,
      required String description,
      required String posterId}) async {
    try {
      MagazineModel magazineModel = MagazineModel(
          id: const Uuid().v1(),
          name: name,
          authorname: authorName,
          description: description,
          file: '',
          posterId: posterId,
          thumbnail: '');
      print('impl le poster id is $posterId');
      final imageUrl = await magazineRemoteDataSource.uploadMagazinePdf(
          file: pdf, magazineModel: magazineModel);
      final thumbnailUrl = await magazineRemoteDataSource.uploadThumbnail(
          file: thumbnail, magazineModel: magazineModel);

      magazineModel =
          magazineModel.copyWith(file: imageUrl, thumbnail: thumbnailUrl);
      Map<String, dynamic> map = magazineModel.toMap();
      print('rep impl is $map');
      final magData =
          await magazineRemoteDataSource.uploadMagazine(magazineModel);
      return right(magData);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Magazine>>> getAllMagazine() async {
    try {
      final magaList = await magazineRemoteDataSource.getMagazine();
      return right(magaList);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> likeMagazine(
      {required String magazineId, required String userId}) async {
    try {
      return right(
          await magazineRemoteDataSource.likeMagazine(magazineId, userId));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Stream<Either<Failure, List<String>>> subscribeToLikes(
      {required String magazineId}) async* {
    try {
      final stream = magazineRemoteDataSource.subscribeToLikes(magazineId);
      await for (final likes in stream) {
        yield Right(likes);
      }
    } on ServerException catch (e) {
      yield Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addComment(
      {required String magazineId,
      required String userId,
      required String commentText}) async {
    try {
      await magazineRemoteDataSource.addComment(
          magazineId, userId, commentText);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getComments(String magazineId) async {
    try {
      final comments = await magazineRemoteDataSource.getComments(magazineId);
      return right(comments);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
