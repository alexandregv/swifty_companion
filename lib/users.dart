import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:loader/loader.dart';
import 'package:http/http.dart' as http;

import 'models/project_user.dart';
import 'models/user.dart';

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
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Tab1(helper: _helper, login: widget.login, user: _user),
              Tab2(helper: _helper, login: widget.login, user: _user),
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

class Tab2 extends StatefulWidget {
  final OAuth2Helper helper;
  final String login;
  final User user;

  const Tab2({
    Key? key,
    required this.helper,
    required this.login,
    required this.user,
  }) : super(key: key);

  @override
  State<Tab2> createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> with LoadingMixin<Tab2>, AutomaticKeepAliveClientMixin<Tab2>{
  late final User _user;
  late final List<ProjectUser> _projectsUsers = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Future<void> load() async {
    http.Response resp = await widget.helper.get("https://api.intra.42.fr/v2/users/${widget.login}/projects_users");
    if (resp.statusCode == 200) {
      setState(() {
        for (Map<String, dynamic> projectUser in json.decode(resp.body)) {
          _projectsUsers.add(ProjectUser.fromJson(projectUser));
        }
      });
    } else if (resp.statusCode == 404) {
      throw Exception("ProjectUsers not found");
    } else {
      throw Exception("Error retrieving user's projects");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (hasError) {
      return Center(child: Text('Error PU ' + error.toString()));
    } else {
      return buildBody(context);
    }
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.start, // Align to left
          children: () {
            if (_projectsUsers.isEmpty) {
              return <Widget>[
                const Center(child: Text('User has no projects')),
              ];
            } else {
              _projectsUsers.sort((a, b) => a.id.compareTo(b.id));
              return <Widget>[
                for (ProjectUser projectUser in _projectsUsers)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text("${projectUser.id}: ${projectUser.finalMark}"),
                  ),
              ];
            }
          }(),
        )
    );
  }
}
