class User {
  final String id;
  final String email;
  final String name;
  final String? profilePic;
  final String? bio;
  final String? type;

  User(
      {required this.id,
      required this.type,
      required this.email,
      required this.name,
      this.bio,
      this.profilePic});
}
