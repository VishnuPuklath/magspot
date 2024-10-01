import 'package:fpdart/fpdart.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/core/usecase/usecase.dart';
import 'package:magspot/features/magazine/domain/repository/magazine_repository.dart';

class AddCommentUsecase implements Usecase<void, AddCommentParams> {
  final MagazineRepository magazineRepository;

  AddCommentUsecase({required this.magazineRepository});
  @override
  Future<Either<Failure, void>> call(AddCommentParams params) {
    return magazineRepository.addComment(
      magazineId: params.magazineId,
      userId: params.userId,
      commentText: params.commentText,
    );
  }
}

class AddCommentParams {
  final String magazineId;
  final String userId;
  final String commentText;

  AddCommentParams({
    required this.magazineId,
    required this.userId,
    required this.commentText,
  });
}
