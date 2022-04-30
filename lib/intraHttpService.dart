import 'package:http/http.dart' as http;
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class IntraHttpService {
  final String _baseUrl = "https://api.intra.42.fr/v2/";
  late final OAuth2Helper _helper;
  final http.Client _client = http.Client();

  final OAuth2Client client = OAuth2Client(
    authorizeUrl: 'https://api.intra.42.fr/oauth/authorize',
    tokenUrl: 'https://api.intra.42.fr/oauth/token',
    redirectUri: 'my.flutterycompanion://oauth2redirect',
    customUriScheme: 'my.flutterycompanion',
  );

  IntraHttpService() {
    _helper = OAuth2Helper(client,
      grantType: OAuth2Helper.AUTHORIZATION_CODE,
      clientId: '<API_APP_CLIENT_ID>',
      clientSecret: '<API_APP_CLIENT_SECRET>',
      scopes: ['public', 'profile', 'projects'],
    );
  }

  Future<dynamic> get(String route) async {
    final String concat = _baseUrl + route;
    http.Response response = await _helper.get(concat);
    return response;
  }
}