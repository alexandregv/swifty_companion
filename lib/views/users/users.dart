import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:http/http.dart' as http;
import 'package:swifty_companion/views/users/tab1.dart';
import 'package:swifty_companion/views/users/tab2.dart';
import 'package:swifty_companion/views/users/tab3.dart';

import '../../intra_http_service.dart';
import '../../models/user.dart';

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
  final IntraHttpService _intraHttpService = IntraHttpService();
  late User _user;
  ImageProvider _userImage = const NetworkImage("https://cdn.intra.42.fr/users/medium_default.jpg");

  Future <void> refreshUser() async {
    setState(() => loading = true);
    final User user = await _intraHttpService.getUser(widget.login);
    setState(() {
      _user = user;
      loading = false;
    });
  }

  Future <void> refreshUserImage(User user) async {
    setState(() => loading = true);
    final ImageProvider img = await _intraHttpService.getUserImage(_user);
    setState(() {
      _userImage = img;
      loading = false;
    });
  }

  @override
  Future<void> load() async {
    final User user = await _intraHttpService.getUser(widget.login);
    final ImageProvider img = await _intraHttpService.getUserImage(user);
    setState(() {
      _user = user;
      _userImage = img;
    });
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
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => refreshUser(),
              ),
            ],
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
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => refreshUser(),
            ),
          ],
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
            Tab1(intraHttpService: _intraHttpService, login: widget.login, user: _user, userImage: _userImage),
            Tab2(intraHttpService: _intraHttpService, login: widget.login),
            Tab3(intraHttpService: _intraHttpService, login: widget.login, user: _user),
          ],
        ),
      ),
    );
  }
}