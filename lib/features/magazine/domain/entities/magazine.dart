class Magazine {
  final String id;
  final String name;
  final String authorname;
  final String description;
  final String file;
  final String thumbnail;
  final String posterId;
  final String? posterName;
  Magazine({
    required this.thumbnail,
    required this.id,
    required this.name,
    required this.posterId,
    required this.authorname,
    required this.description,
    required this.file,
    this.posterName,
  });
}
