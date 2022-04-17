import 'package:flutter/material.dart';
import 'package:swifty_companion/search.dart';


import 'about.dart';
import 'login.dart';

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
      routes: {
        '/': (context) => const LoginPage(),
        '/search': (context) => const SearchPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}