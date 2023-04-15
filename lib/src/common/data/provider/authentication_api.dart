import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import 'package:trailbrake/src/common/data/model/model.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class AuthenticationResponse {
  AuthenticationResponse(this.httpCode, this.token);

  final int httpCode;
  final Token? token;
}

class AuthenticationAPI {
  final String authUrl = '${constants.trailbrakeApiUrl}/auth';
  http.Client client = http.Client();

  Future<http.Response> postCredentials(
      Uri url, String email, Digest hashedPassword) async {
    final headers = {'Content-Type': 'application/json'};
    final body =
        jsonEncode({'email': email, 'password': hashedPassword.toString()});

    final response = await client.post(url, headers: headers, body: body);

    return response;
  }

  Future<AuthenticationResponse> getToken(
      String email, Digest hashedPassword) async {
    final url = Uri.parse('$authUrl/token');
    final response = await postCredentials(url, email, hashedPassword);

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      return AuthenticationResponse(200, Token.fromJson(responseBody));
    } else {
      return AuthenticationResponse(response.statusCode, null);
    }
  }

  Future<AuthenticationResponse> validateToken(String token) async {
    final url = Uri.parse('$authUrl/token');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await client.head(url, headers: headers);

    if (response.statusCode == 200) {
      return AuthenticationResponse(200, Token(tokenString: token));
    } else {
      return AuthenticationResponse(response.statusCode, null);
    }
  }

  Future<AuthenticationResponse> createUser(
      String email, Digest hashedPassword) async {
    final url = Uri.parse('$authUrl/signup');
    final response = await postCredentials(url, email, hashedPassword);

    if (response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      return AuthenticationResponse(201, Token.fromJson(responseBody));
    } else {
      return AuthenticationResponse(response.statusCode, null);
    }
  }
}
