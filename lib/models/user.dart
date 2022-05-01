import 'package:swifty_companion/models/cursus_user.dart';

class User {
  final String login;
  final String firstname;
  final String lastname;
  final String usualFirstName;
  final String usualFullName;
  final String email;
  final String location;
  final String imageUrl;
  final String newImageUrl;
  final List<CursusUser> cursusUsers;
  final String poolMonth;
  final String poolYear;
  final bool isStaff;
  final int wallet;
  final int evaluationPoints;
  final String title;
  late CursusUser? primaryCursus;
  late DateTime? blackholedAt;

  User({
      required this.login,
      required this.firstname,
      required this.lastname,
      required this.usualFirstName,
      required this.usualFullName,
      required this.email,
      required this.location,
      required this.imageUrl,
      required this.newImageUrl,
      required this.cursusUsers,
      required this.poolMonth,
      required this.poolYear,
      required this.isStaff,
      required this.wallet,
      required this.evaluationPoints,
      required this.title
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final String title = () {
      if (json["titles_users"] != null &&
          (json["titles_users"] as List<dynamic>).isNotEmpty) {
        final selectedTitleUser = (json["titles_users"] as List<dynamic>)
            .firstWhere((tu) => tu["selected"] == true, orElse: () => null);
        if (selectedTitleUser != null) {
          final int titleUserId = (json["titles_users"] as List<dynamic>)
              .firstWhere((tu) => tu["selected"] == true)["title_id"];
          final selectedTitle = (json["titles"] as List<dynamic>)
              .firstWhere((t) => t["id"] == titleUserId, orElse: () => null);
          if (selectedTitle != null) {
            final String titleName = (json["titles"] as List<dynamic>)
                .firstWhere((t) => t["id"] == titleUserId)["name"];
            return titleName.replaceAll("%login", json["login"]);
          }
        }
      }
      return "";
    }();

    User user = User(
      login: json["login"],
      firstname: json["first_name"],
      lastname: json["last_name"],
      usualFirstName: json["usual_first_name"] ?? json["first_name"],
      usualFullName: json["usual_full_name"],
      email: json["email"],
      location: json["location"] ?? 'Unavailable',
      imageUrl: json["image_url"],
      newImageUrl: json["new_image_url"],
      cursusUsers: <CursusUser>[
        for (Map<String, dynamic> cursusUser in json["cursus_users"] ?? [])
          CursusUser.fromJson(cursusUser),
      ],
      poolMonth: json["pool_month"] ?? 'none',
      poolYear: json["pool_year"] ?? 'none',
      isStaff: json["staff?"] ?? false,
      wallet: json["wallet"] ?? 0,
      evaluationPoints: json["evaluation_points"] ?? 0,
      title: title,
    );

    user.cursusUsers.sort((a, b) => a.id.compareTo(b.id));

    user.primaryCursus = user.cursusUsers.isEmpty
        ? null
        : user.cursusUsers.firstWhere((e) => e.cursus.name == '42cursus',
            orElse: () => user.cursusUsers.firstWhere(
                (e) => e.cursus.name == '42',
                orElse: () => user.cursusUsers.last));

    if (user.primaryCursus == null) {
      user.blackholedAt = null;
    } else {
      user.blackholedAt = user.primaryCursus!.blackholedAt;
    }

    return user;
  }

  @override
  String toString() {
    return 'User: $login $usualFullName $email';
  }
}
