import 'package:fpdart/src/either.dart';
import 'package:magspot/core/entities/user.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/core/usecase/usecase.dart';
import 'package:magspot/features/auth/domain/repository/auth_repository.dart';

class UserSignout implements Usecase<User?, NoParams> {
  final AuthRepository authRepository;

  UserSignout({required this.authRepository});
  @override
  Future<Either<Failure, User?>> call(params) {
    return authRepository.signOut();
  }
}
