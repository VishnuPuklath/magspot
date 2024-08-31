import 'package:fpdart/src/either.dart';
import 'package:magspot/core/error/exceptions.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/features/auth/data/datasources/auth_data_remote_data_source.dart';
import 'package:magspot/core/entities/user.dart';
import 'package:magspot/features/auth/domain/repository/auth_repository.dart';

class AuthRepositorImpl implements AuthRepository {
  final AuthDataRemoteDataSource remoteDataSource;

  AuthRepositorImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> loginWIthEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userModel = await remoteDataSource.loginWithEmailAndPassword(
          email: email, password: password);
      return right(userModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWIthEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final userModel = await remoteDataSource.signUpWithEmailAndPassword(
          name: name, email: email, password: password);
      return right(userModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      if (user == null) {
        return left(Failure('User not logged in'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User?>> signOut() async {
    try {
      final res = await remoteDataSource.signOut();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
  //   try {
  //     final user = await fn();
  //     return right(user);
  //   } on ServerException catch (e) {
  //     return left(Failure(e.message));
  //   }
  // }
}
