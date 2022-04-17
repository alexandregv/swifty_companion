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
  late OAuth2Helper _helper;
  late String _firstname = "Error";

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
        scopes: ['public', 'profile', 'projects']
    );

    http.Response resp = await _helper.get("https://api.intra.42.fr/v2/users/${widget.login}");
    if (resp.statusCode == 200) {
      _firstname = json.decode(resp.body)['usual_full_name'];
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
              Tab(icon: Icon(Icons.area_chart)),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.start, // Align to left
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Text("User found: $_firstname"),
            ),
          ],
        )
      ),
    );
  }
}
