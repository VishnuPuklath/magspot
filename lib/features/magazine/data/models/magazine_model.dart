import 'package:magspot/features/magazine/domain/entities/magazine.dart';

class MagazineModel extends Magazine {
  MagazineModel({
    required super.id,
    required super.name,
    required super.authorName,
    required super.description,
    required super.file,
    required super.posterId,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'authorName': authorName,
      'description': description,
      'file': file,
    };
  }

  factory MagazineModel.fromMap(Map<String, dynamic> map) {
    return MagazineModel(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        authorName: map['authorName'] ?? '',
        description: map['description'] ?? '',
        file: map['file'] ?? '',
        posterId: map['posterId'] ?? '');
  }
  MagazineModel copyWith({
    String? id,
    String? name,
    String? authorName,
    String? description,
    String? file,
    String? posterId,
  }) {
    return MagazineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      authorName: authorName ?? this.authorName,
      description: description ?? this.description,
      file: file ?? this.file,
      posterId: posterId ?? this.posterId,
    );
  }
}
