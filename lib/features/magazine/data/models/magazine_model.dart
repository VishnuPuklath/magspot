import 'package:magspot/features/magazine/domain/entities/magazine.dart';

class MagazineModel extends Magazine {
  MagazineModel(
      {required super.id,
      super.likes,
      super.comments,
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
      'likes': likes,
      'comments': comments
    };
  }

  factory MagazineModel.fromMap(Map<String, dynamic> map) {
    return MagazineModel(
        comments: map['comments'] ?? [],
        likes: (map['likes'] as List<dynamic>?)
                ?.map((item) => item.toString())
                .toList() ??
            [],
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
      String? thumbnail,
      List}) {
    return MagazineModel(
        thumbnail: thumbnail ?? this.thumbnail,
        id: id ?? this.id,
        posterName: posterName ?? this.posterName,
        name: name ?? this.name,
        authorname: authorname ?? this.authorname,
        description: description ?? this.description,
        file: file ?? this.file,
        posterId: posterId ?? this.posterId,
        comments: comments ?? this.comments,
        likes: likes ?? this.likes);
  }
}
