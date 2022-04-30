import 'dart:convert' as convert;

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
    http.Response response = await _helper.get(_baseUrl + route);
    return response;
  }

  Future<http.Response> getPages(String route) async {
    final Uri receivedUri = Uri.parse(_baseUrl + route);
    final Uri newUri = receivedUri.replace(
      queryParameters: {
        'page[number]': '1',
        'page[size]': '100',
        ...receivedUri.queryParameters,
      },
    );

    http.Response response = await _helper.get(newUri.toString());
    if (response.statusCode == 200) { //TODO: add 2nd condition to avoid crafting a paginated request if x-total is 1
      String craftedBody = response.body;

      if (response.headers["x-total"] != null && response.headers["x-per-page"] != null) {
        final int xTotal = int.parse(response.headers["x-total"] ?? '0');
        final int xPerPage = int.parse(response.headers["x-per-page"] ?? '100');
        final int totalPages = xTotal ~/ xPerPage + 1;

        if (totalPages > 1) {
          for (int i = 2; i <= totalPages; i++) {
            final Uri newUri = receivedUri.replace(
              queryParameters: {
                'page[size]': '100',
                ...receivedUri.queryParameters,
                'page[number]': i.toString(),
              },
            );
            http.Response response = await _helper.get(newUri.toString());
            List<dynamic> arr = convert.jsonDecode(craftedBody);
            arr.addAll(convert.jsonDecode(response.body));
            craftedBody = convert.jsonEncode(arr);
          }
        }
      }

      final http.Response craftedResponse = http.Response(
        craftedBody,
        response.statusCode,
        headers: response.headers,
      );
      return craftedResponse;
    } else {
      return response;
    }
  }
}