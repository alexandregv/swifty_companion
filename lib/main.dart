import 'package:flutter/cupertino.dart';
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
      //routes: {
      //  '/': (context) => const LoginPage(),
      //  '/search': (context) => const SearchPage(),
      //  '/about': (context) => const AboutPage(),
      //},
      onGenerateRoute: (RouteSettings settings) {
        late StatefulWidget page;
        switch (settings.name) {
          case '/': page = const LoginPage(); break;
          case '/search': page = const SearchPage(); break;
          case '/about': page = const AboutPage(); break;
        }
        return CupertinoPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}