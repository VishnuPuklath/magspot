import 'package:magspot/core/entities/user.dart';

class UserModel extends User {
  UserModel(
      {required super.id,
      required super.email,
      required super.name,
      super.bio,
      super.profilePic});

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'] ?? '',
        email: map['email'] ?? '',
        name: map['name'] ?? '',
        bio: map['bio'] ?? '',
        profilePic: map['profile'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'bio': bio
    };
  }

  UserModel copyWith(
      {String? id,
      String? email,
      String? name,
      String? bio,
      String? profilePic}) {
    return UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        bio: bio ?? this.bio,
        profilePic: profilePic ?? this.profilePic);
  }
}
