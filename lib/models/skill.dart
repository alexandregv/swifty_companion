class Skill {
  final int id;
  final String slug;
  final String name;

  Skill({required this.id, required this.slug, required this.name});

  factory Skill.fromJson(Map<String, dynamic> json) {
    Skill skill = Skill(
      id: json["id"],
      slug: json["slug"],
      name: json["name"],
    );
    return skill;
  }

  @override
  String toString() {
    return 'Skill: $id $slug $name';
  }
}
