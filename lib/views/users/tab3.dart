import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:loader/loader.dart';
import 'package:http/http.dart' as http;

import '../../models/skill_user.dart';
import '../../models/user.dart';

class Tab3 extends StatefulWidget {
  final OAuth2Helper helper;
  final String login;
  final User user;

  const Tab3({
    Key? key,
    required this.helper,
    required this.login,
    required this.user,
  }) : super(key: key);

  @override
  State<Tab3> createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> with LoadingMixin<Tab3>, AutomaticKeepAliveClientMixin<Tab3>{
  late final List<SkillUser> _skillUsers = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> load() async {
    final _primaryCursus = widget.user.cursusUsers.isEmpty ? null :
    widget.user.cursusUsers.firstWhere((e) => e['cursus']['name'] == '42cursus',
        orElse: () => widget.user.cursusUsers.firstWhere((e) => e['cursus']['name'] == '42',
            orElse: () => widget.user.cursusUsers.last))
    ;

    http.Response resp = await widget.helper.get("https://api.intra.42.fr/v2/users/${widget.login}"); //TODO: Get all pages
    if (resp.statusCode == 200) {
      setState(() {
        Map<String, dynamic> userBody = json.decode(resp.body);
        for (Map<String, dynamic> cursusUser in userBody["cursus_users"]) {
          if (cursusUser["id"] == _primaryCursus['id']) {
            for (Map<String, dynamic> skill in cursusUser["skills"]) {
              _skillUsers.add(SkillUser.fromJson(skill));
            }
          }
        }
      });
    } else if (resp.statusCode == 404) {
      throw Exception("Skills not found");
    } else {
      throw Exception("Error retrieving user's skills");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (hasError) {
      return Center(child: Text('Error SkillUser ' + error.toString()));
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
            if (_skillUsers.isEmpty) {
              return <Widget>[
                const Center(child: Text('User has no experiences')),
              ];
            } else {
              _skillUsers.sort((a, b) => b.level.compareTo(a.level));
              return <Widget>[
                for (SkillUser skillUser in _skillUsers)
                  skillUserInfo(context, skillUser),
              ];
            }
          }(),
        )
    );
  }

  Padding skillUserInfo(BuildContext context, SkillUser skillUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: ListTile(
        title: Text("${skillUser.skillName}: ${skillUser.level}"),
      ),
    );
  }
}