import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

import 'models/user.dart';

class IntraHttpService {
  final String _baseUrl = "https://api.intra.42.fr/v2/";
  late final OAuth2Helper _helper;

  final OAuth2Client client = OAuth2Client(
    authorizeUrl: 'https://api.intra.42.fr/oauth/authorize',
    tokenUrl: 'https://api.intra.42.fr/oauth/token',
    redirectUri: 'my.flutterycompanion://oauth2redirect',
    customUriScheme: 'my.flutterycompanion',
  );

  IntraHttpService() {
    _helper = OAuth2Helper(
      client,
      grantType: OAuth2Helper.AUTHORIZATION_CODE,
      clientId: '<API_APP_CLIENT_ID>',
      clientSecret: '<API_APP_CLIENT_SECRET>',
      scopes: ['public', 'profile', 'projects'],
    );
  }

  Future<dynamic> getToken() async {
   return _helper.getToken();
  }

  Future<dynamic> get(String route, {retryCount = 0}) async {
    http.Response response = await _helper.get(_baseUrl + route);
    if (response.statusCode == 429) {
      if (retryCount > 3) {
        throw Exception("Rate limit exceeded, too many retries (3).");
      }
      final int retryAfter = int.parse(response.headers['retry-after'] ?? '1');
      await Future.delayed(Duration(seconds: retryAfter));
      return get(route, retryCount: retryCount + 1);
    }

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
    final int xTotal = int.parse(response.headers["x-total"] ?? '0');
    final int xPerPage = int.parse(response.headers["x-per-page"] ?? '100');
    final int xPage = int.parse(response.headers["x-page"] ?? '1');
    final int totalPages = xTotal ~/ xPerPage + 1;

    if (response.statusCode == 200 && totalPages > 1) {
      String craftedBody = response.body;

      if (response.headers["x-total"] != null &&
          response.headers["x-per-page"] != null &&
          response.headers["x-page"] != null) {
        if (xPage <= totalPages) {
          List<dynamic> arr = convert.jsonDecode(craftedBody);
          final nextPage = xPage + 1;
          final Uri nextUri = newUri.replace(
            queryParameters: {
              ...receivedUri.queryParameters,
              'page[number]': nextPage.toString(),
            },
          );
          http.Response nextResponse = await getPages(nextUri.path.split("/v2/")[1] + '?' + nextUri.query);
          arr.addAll(convert.jsonDecode(nextResponse.body));
          craftedBody = convert.jsonEncode(arr);
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

  Future<User> getUser(String login) async {
    http.Response resp = await get("/users/$login");
    if (resp.statusCode == 200) {
      return User.fromJson(convert.jsonDecode(resp.body));
    } else if (resp.statusCode == 404) {
      throw Exception("User not found");
    } else {
      throw Exception("Error retrieving user");
    }
  }

  Future<ImageProvider> getUserImage(User user) async {
    final List<String> split = user.imageUrl.split("/");
    final String last = split.removeLast();
    final String mediumUrl = split.join("/") + "/medium_" + last;

    http.Response r = await http.get(Uri.parse(mediumUrl));
    if (r.statusCode == 200) {
      return MemoryImage(r.bodyBytes);
    } else {
      r = await http.get(Uri.parse(mediumUrl));
      if (r.statusCode == 200) {
        return MemoryImage(r.bodyBytes);
      } else {
        return const NetworkImage("https://cdn.intra.42.fr/users/medium_default.jpg");
      }
    }
  }
}