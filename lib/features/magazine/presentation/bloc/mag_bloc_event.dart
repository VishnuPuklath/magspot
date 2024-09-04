part of 'mag_bloc_bloc.dart';

@immutable
sealed class MagBlocEvent {}

final class MagazineUpload extends MagBlocEvent {
  final String posterId;
  final String name;
  final String authorname;
  final String description;
  final File file;

  MagazineUpload(
      {required this.posterId,
      required this.name,
      required this.authorname,
      required this.description,
      required this.file});
}
