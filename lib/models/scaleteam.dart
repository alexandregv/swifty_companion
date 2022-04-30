
class ScaleTeam {
  final int id;
  final DateTime beginAt;
  final List<dynamic> correcteds;
  final Map<String, dynamic> corrector;
  late DateTime? filledAt;

  ScaleTeam({required this.id, required this.beginAt, required this.correcteds, required this.corrector});

  factory ScaleTeam.fromJson(Map<String, dynamic> json) {
    ScaleTeam projectUser = ScaleTeam(
      id: json["id"],
      beginAt: DateTime.parse(json["begin_at"]),
      correcteds: json["correcteds"],
      corrector: json["corrector"],
    );

    if (json["filled_at"] == null) {
      projectUser.filledAt = null;
    } else {
      projectUser.filledAt = DateTime.parse(json["filled_at"]);
    }

    return projectUser;
  }

  @override
  String toString() {
    return 'ScaleTeam: $id $beginAt $filledAt $corrector $correcteds';
  }
}
