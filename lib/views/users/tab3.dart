import 'package:flutter/material.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:loader/loader.dart';

import '../../intraHttpService.dart';
import '../../models/skill_user.dart';
import '../../models/user.dart';

class Tab3 extends StatefulWidget {
  final IntraHttpService intraHttpService;
  final String login;
  final User user;

  const Tab3({
    Key? key,
    required this.intraHttpService,
    required this.login,
    required this.user,
  }) : super(key: key);

  @override
  State<Tab3> createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> with LoadingMixin<Tab3>, AutomaticKeepAliveClientMixin<Tab3>{
  late List<SkillUser> _skillUsers = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> load() async {
    if (widget.user.primaryCursus != null) {
      setState(() {
        _skillUsers = widget.user.primaryCursus!.skillUsers;
      });
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
        title: Text("${skillUser.skillName}: ${skillUser.level.toStringAsFixed(2)}"),
      ),
    );
  }
}