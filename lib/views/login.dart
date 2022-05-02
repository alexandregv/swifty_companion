import 'package:flutter/material.dart';
import 'package:swifty_companion/views/search.dart';

import '../intra_http_service.dart';

class LoginPage extends StatefulWidget {
  final IntraHttpService intraHttpService;

  const LoginPage({
    Key? key,
    required this.intraHttpService,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _tokenInfo = 'Waiting...';

  void _initOAuth() async {
    var tokenResp = await widget.intraHttpService.getToken();
    setState(() {
      _tokenInfo = tokenResp.toString();
    });
  }

  @override
  void initState() {
    super.initState();

    _initOAuth();
  }

  @override
  Widget build(BuildContext context) {
    if (_tokenInfo != 'Waiting...') {
      return const SearchPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('OAuth'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Token Info: ' + _tokenInfo),
      ),
    );
  }
}
