import 'dart:io';
import 'package:fpdart/src/either.dart';
import 'package:magspot/core/entities/user.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/core/usecase/usecase.dart';
import 'package:magspot/features/profile/domain/repository/profile_repository.dart';

class UserProfileUpdation implements Usecase<User, ProfileUpdationParams> {
  final ProfileRepository profileRepository;

  UserProfileUpdation({required this.profileRepository});
  @override
  Future<Either<Failure, User>> call(params) {
    return profileRepository.updateProfile(
        id: params.id, name: params.name, bio: params.bio, file: params.file);
  }
}

class ProfileUpdationParams {
  final String id;
  final String name;
  final String bio;
  final File? file;

  ProfileUpdationParams(
      {required this.id,
      required this.name,
      required this.bio,
      required this.file});
}
