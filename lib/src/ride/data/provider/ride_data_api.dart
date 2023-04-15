import 'dart:convert';

import 'package:trailbrake/src/ride/data/data.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;
import 'package:trailbrake/src/common/common.dart';

class RideDataAPIResponse {
  RideDataAPIResponse(this.httpCode, this.responseBody);

  final int httpCode;
  dynamic responseBody;
}

class RideDataAPI {
  final String baseUrl = constants.trailbrakeApiUrl;
  AuthorizedHttpClient client = AuthorizedHttpClient();

  Future<RideDataAPIResponse> getRideCatalog() async {
    final response = await client.get(Uri.parse('$baseUrl/rides'));

    final List<RideRecord> allRideHistory = <RideRecord>[];

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      if (responseBody != null) {
        responseBody.forEach((element) {
          allRideHistory.add(RideRecord.fromJson(element));
        });
      }

      return RideDataAPIResponse(200, allRideHistory);
    } else {
      return RideDataAPIResponse(response.statusCode, response.body);
    }
  }

  Future<RideDataAPIResponse> getRideData(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/rides/$id'));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      return RideDataAPIResponse(200, SavedRide.fromJson(responseBody));
    } else {
      return RideDataAPIResponse(response.statusCode, response.body);
    }
  }

  Future<RideDataAPIResponse> saveRideData(NewRide postBody) async {
    final response = await client.post(
      Uri.parse('$baseUrl/rides'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(postBody),
    );

    if (response.statusCode == 201) {
      final responseJson = jsonDecode(response.body);

      return RideDataAPIResponse(201, RideRecord.fromJson(responseJson));
    } else {
      return RideDataAPIResponse(response.statusCode, response.body);
    }
  }

  Future<RideDataAPIResponse> deleteRideData(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/rides/$id'));

    if (response.statusCode == 204) {
      return RideDataAPIResponse(204, true);
    } else {
      return RideDataAPIResponse(response.statusCode, false);
    }
  }
}
