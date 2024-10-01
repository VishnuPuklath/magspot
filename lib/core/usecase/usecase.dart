import 'package:fpdart/fpdart.dart';
import 'package:magspot/core/error/failure.dart';

abstract interface class Usecase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}

abstract interface class StreamUsecase<SuccessType, Params> {
  Stream<Either<Failure, SuccessType>> call(Params params);
}
