import 'package:magspot/features/magazine/domain/entities/magazine.dart';

class MagazineModel extends Magazine {
  MagazineModel({
    required super.id,
    required super.name,
    required super.authorname,
    required super.description,
    required super.file,
    required super.posterId,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'authorname': authorname,
      'description': description,
      'file': file,
      'posterid': posterId
    };
  }

  factory MagazineModel.fromMap(Map<String, dynamic> map) {
    return MagazineModel(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        authorname: map['authorname'] ?? '',
        description: map['description'] ?? '',
        file: map['file'] ?? '',
        posterId: map['posterId'] ?? '');
  }
  MagazineModel copyWith({
    String? id,
    String? name,
    String? authorname,
    String? description,
    String? file,
    String? posterId,
  }) {
    return MagazineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      authorname: authorname ?? this.authorname,
      description: description ?? this.description,
      file: file ?? this.file,
      posterId: posterId ?? this.posterId,
    );
  }
}
