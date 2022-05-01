class Project {
  final int id;
  final int parentId;
  final String name;
  final String slug;

  Project({
      required this.id,
      required this.parentId,
      required this.name,
      required this.slug
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    Project project = Project(
      id: json["id"],
      parentId: json["parent_id"] ?? -1,
      name: json["name"],
      slug: json["slug"],
    );
    return project;
  }

  @override
  String toString() {
    return 'ProjectUser: $id $name ($slug)';
  }
}
