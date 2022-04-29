import 'package:swifty_companion/models/skill.dart';

class Experience {
  final int id;
  final int userId;
  final int experience;
  final int cursusId;
  final Skill skill;

  Experience({required this.id, required this.userId, required this.experience, required this.cursusId, required this.skill});

  factory Experience.fromJson(Map<String, dynamic> json) {
    Experience experience = Experience(
      id: json["id"],
      userId: json["user_id"],
      experience: json["experience"],
      cursusId  : json["cursus_id"],
      skill: Skill.fromJson(json["skill"]),
    );
    return experience;
  }

  @override
  String toString() {
    return 'Experience: $id ${skill.slug} $userId $experience';
  }
}
