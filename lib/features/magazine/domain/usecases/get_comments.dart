import 'package:fpdart/fpdart.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/core/usecase/usecase.dart';
import 'package:magspot/features/magazine/domain/entities/comment.dart';
import 'package:magspot/features/magazine/domain/repository/magazine_repository.dart';

class GetCommentsUseCase implements Usecase<List<Comment>, String> {
  final MagazineRepository magazineRepository;

  GetCommentsUseCase({required this.magazineRepository});
  @override
  Future<Either<Failure, List<Comment>>> call(String magazineId) {
    return magazineRepository.getComments(magazineId);
  }
}
