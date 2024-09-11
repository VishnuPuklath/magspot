import 'package:fpdart/fpdart.dart';
import 'package:magspot/core/error/failure.dart';
import 'package:magspot/core/usecase/usecase.dart';
import 'package:magspot/features/magazine/domain/entities/magazine.dart';
import 'package:magspot/features/magazine/domain/repository/magazine_repository.dart';

class GetAllMagazine implements Usecase<List<Magazine>, NoParams> {
  final MagazineRepository magazineRepository;

  GetAllMagazine({required this.magazineRepository});
  @override
  Future<Either<Failure, List<Magazine>>> call(params) {
    return magazineRepository.getAllMagazine();
  }
}
