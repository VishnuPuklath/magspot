import 'package:fpdart/fpdart.dart';
import 'package:magspot/core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> signUpWIthEmailAndPassword(
      {required String name, required String email, required String password});

  Future<Either<Failure, String>> loginWIthEmailAndPassword(
      {required String email, required String password});
}
