class SkillUser {
  final int skillId;
  final String skillName;
  final double level;

  SkillUser({
    required this.skillId,
    required this.skillName,
    required this.level
  });

  factory SkillUser.fromJson(Map<String, dynamic> json) {
    SkillUser skillUser = SkillUser(
      skillId: json["id"],
      skillName: json["name"],
      level: json["level"] ?? 0,
    );
    return skillUser;
  }

  @override
  String toString() {
    return 'SkillUser: $skillId $skillName $level';
  }
}
