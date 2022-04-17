import 'package:flutter/material.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late OAuth2Helper helper;
  String _tokenInfo = 'Waiting...';

  final OAuth2Client client = OAuth2Client(
    authorizeUrl: 'https://api.intra.42.fr/oauth/authorize',
    tokenUrl: 'https://api.intra.42.fr/oauth/token',
    redirectUri: 'my.flutterycompanion://oauth2redirect',
    customUriScheme: 'my.flutterycompanion',
  );

 void _initOAuth() async {
   var tokenResp = await helper.getToken();
   setState(() {
     _tokenInfo = tokenResp.toString();
   });
 }

  @override
  void initState() {
    super.initState();
    client.accessTokenRequestHeaders = {'Accept': 'application/json'};
    helper = OAuth2Helper(client,
        grantType: OAuth2Helper.AUTHORIZATION_CODE,
        clientId: '<API_APP_CLIENT_ID>',
        clientSecret: '<API_APP_CLIENT_SECRET>',
        scopes: ['public', 'profile', 'projects']
    );
    _initOAuth();
  }

  @override
  Widget build(BuildContext context) {
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
