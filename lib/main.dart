import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swifty_companion/views/search.dart';
import 'package:swifty_companion/views/users/users.dart';

import 'views/about.dart';
import 'views/login.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluttery Companion',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':return CupertinoPageRoute(builder: (_) => const LoginPage(), settings: settings);
          case '/search': return CupertinoPageRoute(builder: (_) => const SearchPage(), settings: settings);
          case '/about': return CupertinoPageRoute(builder: (_) => const AboutPage(), settings: settings);
          case '/users': return CupertinoPageRoute(builder: (_) => UsersPage(login: settings.arguments as String,), settings: settings);
          default: return CupertinoPageRoute(builder: (_) => const LoginPage(), settings: settings);
        }
      },
    );
  }
}