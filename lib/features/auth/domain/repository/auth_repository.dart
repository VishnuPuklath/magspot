import 'package:fpdart/fpdart.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/core/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWIthEmailAndPassword(
      {required String name, required String email, required String password});

  Future<Either<Failure, User>> loginWIthEmailAndPassword(
      {required String email, required String password});

  Future<Either<Failure, User>> currentUser();
  Future<Either<Failure, User?>> signOut();
}
