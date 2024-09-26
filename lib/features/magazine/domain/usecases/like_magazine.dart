import 'package:fpdart/src/either.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/core/usecase/usecase.dart';
import 'package:magspot/features/magazine/domain/repository/magazine_repository.dart';

class LikeMagazineUseCase implements Usecase<void, LikeMagazineParams> {
  final MagazineRepository magazineRepository;

  LikeMagazineUseCase({required this.magazineRepository});
  @override
  Future<Either<Failure, void>> call(params) {
    return magazineRepository.likeMagazine(
        magazineId: params.magazineId, userId: params.userId);
  }
}

class LikeMagazineParams {
  final String magazineId;
  final String userId;

  LikeMagazineParams({required this.magazineId, required this.userId});
}
