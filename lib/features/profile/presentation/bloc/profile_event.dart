part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class ProfileUpdation extends ProfileEvent {
  final String id;
  final String name;
  final String bio;
  final File? file;

  ProfileUpdation(
      {required this.id,
      required this.name,
      required this.bio,
      required this.file});
}
