import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:magspot/core/entities/user.dart';
import 'package:magspot/core/error/failure.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, User>> updateProfile(
      {required String id,
      required String name,
      required String bio,
      required File? file});
}
