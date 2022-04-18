import 'package:swifty_companion/models/project.dart';

class ProjectUser {
  final int id;
  final int occurrence;
  final int finalMark;
  final String status;
  final Project project;

  ProjectUser({required this.id, required this.occurrence, required this.finalMark, required this.status, required this.project});

  factory ProjectUser.fromJson(Map<String, dynamic> json) {
    ProjectUser projectUser = ProjectUser(
      id: json["id"],
      occurrence: json["occurrence"] ?? 0,
      finalMark: json["final_mark"] ?? 0,
      status: json["status"] ?? 'Unknown',
      project: Project.fromJson(json["project"]),
    );
    return projectUser;
  }

  @override
  String toString() {
    return 'ProjectUser: $id ${project.slug} $status';
  }
}
