import 'package:fpdart/src/either.dart';
import 'package:magspot/core/error/exceptions.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/features/auth/data/datasources/auth_data_remote_data_source.dart';
import 'package:magspot/features/auth/domain/repository/auth_repository.dart';

class AuthRepositorImpl implements AuthRepository {
  final AuthDataRemoteDataSource remoteDataSource;

  AuthRepositorImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> loginWIthEmailAndPassword(
      {required String email, required String password}) {
    // TODO: implement loginWIthEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signUpWIthEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final userId = await remoteDataSource.signUpWithEmailAndPassword(
          name: name, email: email, password: password);
      return right(userId);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
