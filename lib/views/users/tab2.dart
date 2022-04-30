import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:http/http.dart' as http;

import '../../intraHttpService.dart';
import '../../models/project_user.dart';

class Tab2 extends StatefulWidget {
  final IntraHttpService intraHttpService;
  final String login;

  const Tab2({
    Key? key,
    required this.intraHttpService,
    required this.login,
  }) : super(key: key);

  @override
  State<Tab2> createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> with LoadingMixin<Tab2>, AutomaticKeepAliveClientMixin<Tab2>{
  late final List<ProjectUser> _projectsUsers = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> load() async {
    http.Response resp = await widget.intraHttpService.getPages("/users/${widget.login}/projects_users?page[size]=50"); //TODO: Get all pages
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
                  projectInfo(context, projectUser),
              ];
            }
          }(),
        )
    );
  }

  Padding projectInfo(BuildContext context, ProjectUser projectUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: () {
        late String title;
        late IconData icon;
        late Color color;

        if (projectUser.status == 'finished') {
          if (projectUser.validated) {
            title = "${projectUser.project.name}: ${projectUser.finalMark}/100";
            color = Colors.green;
            icon = Icons.check;
          } else {
            title = "${projectUser.project.name}: ${projectUser.finalMark}/100";
            color = Colors.red;
            icon = Icons.close;
          }
        } else if (projectUser.status == 'waiting_for_correction') {
          title = "${projectUser.project.name}: ${projectUser.status}";
          color = Colors.grey;
          icon = Icons.hourglass_bottom;
        } else if (projectUser.status == 'in_progress') {
          title = "${projectUser.project.name}: ${projectUser.status}";
          color = Colors.orangeAccent;
          icon = Icons.history_toggle_off;
        } else if (projectUser.status == 'searching_a_group') {
          title = "${projectUser.project.name}: ${projectUser.status}";
          color = Colors.blue;
          icon = Icons.family_restroom;
        } else {
          return ListTile(
            title: Text("${projectUser.project.name}: ${projectUser.status}"),
            subtitle: Text(projectUser.project.slug),
          );
        }

        return ListTile(
          title: Text(title),
          subtitle: Text(projectUser.project.slug),
          trailing: Icon(icon, color: color),
        );
      }(),
    );
  }
}