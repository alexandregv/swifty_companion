import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:loader/loader.dart';
import 'package:http/http.dart' as http;
import 'package:swifty_companion/models/scaleteam.dart';

import '../../models/project_user.dart';

class Tab4 extends StatefulWidget {
  final OAuth2Helper helper;
  final String login;

  const Tab4({
    Key? key,
    required this.helper,
    required this.login,
  }) : super(key: key);

  @override
  State<Tab4> createState() => _Tab4State();
}

class _Tab4State extends State<Tab4> with LoadingMixin<Tab4>, AutomaticKeepAliveClientMixin<Tab4>{
  late final List<ScaleTeam> _scaleTeams = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> load() async {
    http.Response resp = await widget.helper.get("https://api.intra.42.fr/v2/users/tepedago/scale_teams?filter[filled]=false"); //TODO: Get all pages
    //http.Response resp = await widget.helper.get("https://api.intra.42.fr/v2/users/tepedago/scale_teams?filter[filled]=false&range[begin_at]=2022-04-29T22:45:00.000Z,3000-12-12T23:59:59.999Z&page[size]=100"); //TODO: Get all pages
    //http.Response resp = await widget.helper.get("https://api.intra.42.fr/v2/users/supervisor/scale_teams?filter[filled]=false&range[begin_at]=2022-04-29T22:45:00.000Z,3000-12-12T23:59:59.999Z&page[size]=100"); //TODO: Get all pages
    if (resp.statusCode == 200) {
      setState(() {
        for (Map<String, dynamic> scaleTeam in json.decode(resp.body)) {
          _scaleTeams.add(ScaleTeam.fromJson(scaleTeam));
        }
      });
    } else if (resp.statusCode == 404) {
      throw Exception("ScaleTeams not found");
    } else {
      throw Exception("Error retrieving user's scaleteams");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (hasError) {
      return Center(child: Text('Error ScaleTeam ' + error.toString()));
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
            if (_scaleTeams.isEmpty) {
              return <Widget>[
                const Center(child: Text('User has no future scaleteams')),
              ];
            } else {
              _scaleTeams.sort((a, b) => a.id.compareTo(b.id));
              return <Widget>[
                for (ScaleTeam scaleTeam in _scaleTeams)
                  scaleTeamInfo(context, scaleTeam),
              ];
            }
          }(),
        )
    );
  }

  Padding scaleTeamInfo(BuildContext context, ScaleTeam scaleTeam) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child:
      ListTile(
        title: Text(scaleTeam.corrector['login']),
        subtitle: Text(scaleTeam.correcteds.map((e) => e['login']).join(', ')),
      ),
    );
  }
}