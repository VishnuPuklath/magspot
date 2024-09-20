class User {
  final String id;
  final String email;
  final String name;
  final String? profilePic;
  final String? bio;

  User(
      {required this.id,
      required this.email,
      required this.name,
      this.bio,
      this.profilePic});
}
