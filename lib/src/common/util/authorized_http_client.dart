import 'package:http/http.dart' as http;

import 'package:trailbrake/src/common/data/data.dart';

/// This class implements a single HTTP client
// class MySingleHttpClient {
//   // _internal() is a private constructor only accessible within the class
//   static final MySingleHttpClient _singleton = MySingleHttpClient._internal();

//   // Ensures only one instance of MySingleHttpClient is created
//   factory MySingleHttpClient() {
//     return _singleton;
//   }

//   // Class constructor
//   MySingleHttpClient._internal();

//   final http.Client _client = http.Client();

//   http.Client get client => _client;
// }

/// This class extends the base client and overrides send() method to include authorization
class AuthorizedHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  final AuthenticationRepository authRepo = AuthenticationRepository();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    var token = await authRepo.getToken();
    request.headers['Authorization'] = 'Bearer $token';

    return _inner.send(request);
  }
}
