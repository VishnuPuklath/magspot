part of 'mag_bloc_bloc.dart';

@immutable
sealed class MagBlocEvent {}

final class MagazineUpload extends MagBlocEvent {
  final String posterId;
  final String name;
  final String authorname;
  final String description;
  final File file;
  final File thumbnail;

  MagazineUpload(
      {required this.posterId,
      required this.thumbnail,
      required this.name,
      required this.authorname,
      required this.description,
      required this.file});
}

final class MagazineGetAllEvent extends MagBlocEvent {}

final class LikeMagazine extends MagBlocEvent {
  final String magazineId;
  final String userId;

  LikeMagazine({required this.magazineId, required this.userId});
}

final class SubscribeToLikesEvent extends MagBlocEvent {
  final String magazineId;

  SubscribeToLikesEvent({required this.magazineId});
}
