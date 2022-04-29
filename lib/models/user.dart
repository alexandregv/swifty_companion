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
  final List<dynamic> cursusUsers;
  final String poolMonth;
  final String poolYear;
  final bool isStaff;

  User({required this.login, required this.firstname, required this.lastname, required this.usualFirstName , required this.usualFullName, required this.email, required this.location, required this.imageUrl, required this.newImageUrl, required this.cursusUsers, required this.poolMonth, required this.poolYear, required this.isStaff});

  factory User.fromJson(Map<String, dynamic> json) {
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
      cursusUsers: json["cursus_users"] ?? [],
      poolMonth: json["pool_month"] ?? 'none',
      poolYear: json["pool_year"] ?? 'none',
      isStaff: json["staff?"] ?? false,
    );
    user.cursusUsers.sort((a, b) => a['id'].compareTo(b['id']));
    return user;
  }

  @override
  String toString() {
    return 'User: $login $usualFullName $email';
  }
}