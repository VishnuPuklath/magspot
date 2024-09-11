part of 'mag_bloc_bloc.dart';

@immutable
sealed class MagBlocState {}

final class MagBlocInitial extends MagBlocState {}

final class MagBlocLoading extends MagBlocState {}

final class MagBlocFailure extends MagBlocState {
  final String error;

  MagBlocFailure(this.error);
}

final class MagBlocSuccess extends MagBlocState {
  final Magazine magazine;

  MagBlocSuccess({required this.magazine});
}

final class MagFetchAllSuccess extends MagBlocState {
  final List<Magazine> magazines;

  MagFetchAllSuccess({required this.magazines});
}
