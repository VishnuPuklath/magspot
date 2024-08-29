import 'package:fpdart/fpdart.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWIthEmailAndPassword(
      {required String name, required String email, required String password});

  Future<Either<Failure, User>> loginWIthEmailAndPassword(
      {required String email, required String password});
}
