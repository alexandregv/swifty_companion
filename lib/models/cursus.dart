import 'package:swifty_companion/models/project.dart';

class Cursus {
  final int id;
  final String slug;
  final String name;

  Cursus({
    required this.id,
    required this.name,
    required this.slug
  });

  factory Cursus.fromJson(Map<String, dynamic> json) {
    Cursus cursus = Cursus(
      id: json["id"],
      slug: json["slug"],
      name: json["name"],
    );
    return cursus;
  }

  @override
  String toString() {
    return 'Cursus: $id $slug $name';
  }
}
