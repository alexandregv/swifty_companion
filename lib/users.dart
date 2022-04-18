import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:loader/loader.dart';
import 'package:http/http.dart' as http;

class UsersPage extends StatefulWidget {
  final String login;

  const UsersPage({
    Key? key,
    required this.login,
  }) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> with LoadingMixin<UsersPage> {
  late final OAuth2Helper _helper;
  late final User _user;

  final OAuth2Client client = OAuth2Client(
    authorizeUrl: 'https://api.intra.42.fr/oauth/authorize',
    tokenUrl: 'https://api.intra.42.fr/oauth/token',
    redirectUri: 'my.flutterycompanion://oauth2redirect',
    customUriScheme: 'my.flutterycompanion',
  );

  @override
  Future<void> load() async {
    _helper = OAuth2Helper(client,
        grantType: OAuth2Helper.AUTHORIZATION_CODE,
        clientId: '<API_APP_CLIENT_ID>',
        clientSecret: '<API_APP_CLIENT_SECRET>',
        scopes: ['public', 'profile', 'projects'],
    );

    http.Response resp = await _helper.get("https://api.intra.42.fr/v2/users/${widget.login}");
    if (resp.statusCode == 200) {
      setState(() {
        _user = User.fromJson(json.decode(resp.body));
      });
    } else if (resp.statusCode == 404) {
      throw Exception("User not found");
    } else {
      throw Exception("Error retrieving user");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return buildLoader(context);
    } else if (hasError) {
      return buildUserNotFound(context);
    } else {
      return buildUserFound(context);
    }
  }

  Widget buildLoader(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text(widget.login),
       centerTitle: true,
     ),
     resizeToAvoidBottomInset: false,
     body: const Center(
       child: CircularProgressIndicator(),
     ),
   );
  }

  Widget buildUserNotFound(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text(widget.login),
            centerTitle: true,
          ),
          resizeToAvoidBottomInset: false,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.start, // Align to left
            children: <Widget>[
              Center(
                child: Text("User ${widget.login} not found."),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go back'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
              ),
            ],
          )
      );
  }

  Widget buildUserFound(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.login),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.commit)),
              Tab(icon: Icon(Icons.stacked_bar_chart)),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
          body: TabBarView(
            children: [
              Tab1(helper: _helper, login: widget.login, user: _user),
              //buildTab1(context, _level, _pool),
              buildTab2(context),
              buildTab3(context),
            ],
          ),
      ),
    );
  }

  Widget buildTab2(BuildContext context) {
    return const Icon(Icons.commit);
  }

  Widget buildTab3(BuildContext context) {
    return const Icon(Icons.stacked_bar_chart);
  }
}

class Tab1 extends StatefulWidget {
  final OAuth2Helper helper;
  final String login;
  final User user;

  const Tab1({
    Key? key,
    required this.helper,
    required this.login,
    required this.user,
  }) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> with AutomaticKeepAliveClientMixin<Tab1>{
  late final User _user;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _primaryCursus =_user.cursusUsers.isNotEmpty ? _user.cursusUsers.last : null;
    final _level = _primaryCursus?['level'].toString() ?? 'No cursus';
    final _pool = () {
      if (_user.poolMonth == 'none' && _user.poolYear == 'none') {
        return "none";
      } else if (_user.poolMonth == 'none' && _user.poolYear != 'none') {
        return _user.poolYear;
      } else if (_user.poolMonth != 'none' && _user.poolYear == 'none') {
        return _user.poolMonth;
      } else {
        return "${_user.poolMonth} ${_user.poolYear}";
      }
    }();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      crossAxisAlignment: CrossAxisAlignment.start, // Align to left
      children: <Widget>[
        Image.network(
          _user.imageUrl,
          errorBuilder: (_, __, ___) {
            return Image.network('https://cdn.intra.42.fr/users/default.jpg');
          },
        ),
        userInfo('Full name', _user.usualFullName),
        userInfo('E-mail', _user.email),
        userInfo('Level', _level),
        userInfo('Location', _user.location),
        userInfo('Pool', _pool),
      ],
    );
  }

  Padding userInfo(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text("$key: $value"),
    );
  }
}

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

  User({required this.login, required this.firstname, required this.lastname, required this.usualFirstName , required this.usualFullName, required this.email, required this.location, required this.imageUrl, required this.newImageUrl, required this.cursusUsers, required this.poolMonth, required this.poolYear});

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
    );
    user.cursusUsers.sort((a, b) => a['id'].compareTo(b['id']));
    return user;
  }

  @override
  String toString() {
    return 'User: $login $usualFullName $email';
  }
}
