import 'package:magspot/features/magazine/domain/entities/magazine.dart';

class MagazineModel extends Magazine {
  MagazineModel(
      {required super.id,
      required super.thumbnail,
      required super.name,
      required super.authorname,
      required super.description,
      required super.file,
      required super.posterId,
      super.posterName});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'authorname': authorname,
      'description': description,
      'file': file,
      'posterid': posterId,
      'thumbnail': thumbnail,
    };
  }

  factory MagazineModel.fromMap(Map<String, dynamic> map) {
    return MagazineModel(
        thumbnail: map['thumbnail'] ?? '',
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        authorname: map['authorname'] ?? '',
        description: map['description'] ?? '',
        file: map['file'] ?? '',
        posterId: map['posterid'] ?? '');
  }
  MagazineModel copyWith(
      {String? id,
      String? name,
      String? authorname,
      String? description,
      String? file,
      String? posterId,
      String? posterName,
      String? thumbnail}) {
    return MagazineModel(
      thumbnail: thumbnail ?? this.thumbnail,
      id: id ?? this.id,
      posterName: posterName ?? this.posterName,
      name: name ?? this.name,
      authorname: authorname ?? this.authorname,
      description: description ?? this.description,
      file: file ?? this.file,
      posterId: posterId ?? this.posterId,
    );
  }
}
