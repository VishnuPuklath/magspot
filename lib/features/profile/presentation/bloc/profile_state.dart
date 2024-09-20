part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileUpdateSuccess extends ProfileState {
  final User user;

  ProfileUpdateSuccess({required this.user});
}

final class ProfileLoading extends ProfileState {}

final class ProfileUpdationFailed extends ProfileState {
  final String error;

  ProfileUpdationFailed({required this.error});
}
