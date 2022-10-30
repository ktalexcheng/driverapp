import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:trailbrake/src/ride/data/data.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class RideDataAPIResponse {
  RideDataAPIResponse(this.httpCode, this.responseBody);

  final int httpCode;
  dynamic responseBody;
}

class RideDataAPI {
  final String apiDomain = constants.trailbrakeApiUrl;
  http.Client client = http.Client();

  Future<RideDataAPIResponse> getRideCatalog() async {
    final response = await client.get(Uri.parse('$apiDomain/rides'));

    final List<RideRecord> allRideHistory = <RideRecord>[];

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      responseBody.forEach((element) {
        allRideHistory.add(RideRecord.fromJson(element));
      });

      return RideDataAPIResponse(200, allRideHistory);
    } else {
      return RideDataAPIResponse(response.statusCode, response.body);
    }
  }

  Future<RideDataAPIResponse> getRideData(String id) async {
    final response = await client.get(Uri.parse('$apiDomain/rides/$id'));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      return RideDataAPIResponse(200, SavedRide.fromJson(responseBody));
    } else {
      return RideDataAPIResponse(response.statusCode, response.body);
    }
  }

  Future<RideDataAPIResponse> saveRideData(NewRide postBody) async {
    final response = await client.post(
      Uri.parse('$apiDomain/rides'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(postBody),
    );
    final responseJson = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return RideDataAPIResponse(
          201, RideRecord.fromJson(responseJson['rideRecord']));
    } else {
      return RideDataAPIResponse(response.statusCode, responseJson);
    }
  }

  Future<RideDataAPIResponse> deleteRideData(String id) async {
    final response = await client.delete(Uri.parse('$apiDomain/rides/$id'));

    if (response.statusCode == 200) {
      return RideDataAPIResponse(200, true);
    } else {
      return RideDataAPIResponse(response.statusCode, false);
    }
  }
}
