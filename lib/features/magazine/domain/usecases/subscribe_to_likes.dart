import 'package:fpdart/fpdart.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/core/usecase/usecase.dart';
import 'package:magspot/features/magazine/domain/repository/magazine_repository.dart';

class SubscribeToLikes implements StreamUsecase<List<String>, LikeParams> {
  final MagazineRepository magazineRepository;

  SubscribeToLikes({required this.magazineRepository});
  @override
  Stream<Either<Failure, List<String>>> call(params) {
    return magazineRepository.subscribeToLikes(magazineId: params.magazineId);
  }
}

class LikeParams {
  final String magazineId;

  LikeParams({required this.magazineId});
}
