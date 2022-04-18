class ProjectUser {
  final int id;
  final int occurrence;
  final String finalMark;
  final String status;

  ProjectUser({required this.id, required this.occurrence, required this.finalMark, required this.status});

  factory ProjectUser.fromJson(Map<String, dynamic> json) {
    ProjectUser projectUser = ProjectUser(
      id: json["id"],
      occurrence: json["occurrence"] ?? '0',
      finalMark: json["final_mark"]?.toString() ?? 'No mark yet',
      status: json["status"] ?? 'Unknown',
    );
    return projectUser;
  }

  @override
  String toString() {
    return 'ProjectUser: $id $status';
  }
}
