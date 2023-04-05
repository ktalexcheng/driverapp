// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

import 'package:trailbrake/src/common/data/provider/provider.dart';

class AuthenticationRepository {
  final secureStorage = const FlutterSecureStorage();

  static const String _tokenKey = 'token';
  final AuthenticationAPI authApi = AuthenticationAPI();

  void clearPreferences() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    await secureStorage.deleteAll();
  }

  Future<bool> isAuthenticated() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? token = prefs.getString(_tokenKey);
    String? token = await secureStorage.read(key: _tokenKey);

    return token != null;
  }

  Future<String?> getToken() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? token = prefs.getString(_tokenKey);
    String? token = await secureStorage.read(key: _tokenKey);

    return token;
  }

  Future<String?> login(String email, Digest hashedPassword) async {
    AuthenticationResponse authResponse =
        await authApi.getToken(email, hashedPassword);

    if (authResponse.httpCode == 200) {
      String token = authResponse.token!.tokenString;
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString(_tokenKey, token);
      await secureStorage.write(key: _tokenKey, value: token);

      return token;
    } else {
      return null;
    }
  }

  Future<void> logout() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove(_tokenKey);
    await secureStorage.delete(key: _tokenKey);
  }

  Future<String?> create(String email, Digest hashedPassword) async {
    AuthenticationResponse authResponse =
        await authApi.createUser(email, hashedPassword);

    if (authResponse.httpCode == 200) {
      String token = authResponse.token!.tokenString;
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString(_tokenKey, token);
      await secureStorage.write(key: _tokenKey, value: token);

      return token;
    } else {
      return null;
    }
  }
}
