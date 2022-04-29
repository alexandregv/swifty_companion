import 'package:swifty_companion/models/cursus.dart';
import 'package:swifty_companion/models/skill_user.dart';

class CursusUser {
  final int id;
  final Cursus cursus;
  final double level;
  final List<SkillUser> skillUsers;

  CursusUser({required this.id, required this.cursus, required this.level, required this.skillUsers});

  factory CursusUser.fromJson(Map<String, dynamic> json) {
    CursusUser projectUser = CursusUser(
      id: json["id"],
      cursus: Cursus.fromJson(json["cursus"]),
      level: json["level"] ?? 0.0,
      skillUsers: <SkillUser>[
        for (Map<String, dynamic> skillUser in json["skills"])
          SkillUser.fromJson(skillUser)
      ],
    );
    return projectUser;
  }

  @override
  String toString() {
    return 'CursusUser: $id ${cursus.name} $level';
  }
}
