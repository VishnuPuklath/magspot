import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:magspot/core/entities/user.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/features/profile/data/datasource/profile_data_source.dart';
import 'package:magspot/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileDataSource;

  ProfileRepositoryImpl({required this.profileDataSource});
  @override
  Future<Either<Failure, User>> updateProfile(
      {required String id,
      required String name,
      required String bio,
      required File? file}) async {
    String? profilePic;
    try {
      if (file != null) {
        profilePic = await profileDataSource.uploadProfilePic(id, file);
      }

      final userprofile =
          await profileDataSource.updateProfileUser(name, bio, profilePic);
      return right(userprofile);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
