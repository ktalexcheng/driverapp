import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:trailbrake/src/ride/data/data.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class RideDataAPI {
  final String apiDomain = constants.trailbrakeAPIURL;
  http.Client client = http.Client();

  Future<APIResponse> fetchRideCatalog() async {
    final response = await client.get(Uri.parse('$apiDomain/rides'));

    final List<RideRecord> allRideHistory = <RideRecord>[];

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      responseBody.forEach((element) {
        allRideHistory.add(RideRecord.fromJson(element));
      });

      return APIResponse(200, allRideHistory);
    } else {
      return APIResponse(response.statusCode, response.body);
    }
  }

  Future<APIResponse> fetchRideData(String id) async {
    final response = await client.get(Uri.parse('$apiDomain/rides/$id'));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      return APIResponse(200, SavedRide.fromJson(responseBody));
    } else {
      return APIResponse(response.statusCode, response.body);
    }
  }

  Future<APIResponse> saveRideData(NewRide postBody) async {
    print(jsonEncode(postBody));
    final response = await client.post(
      Uri.parse('$apiDomain/rides'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(postBody),
    );
    final responseJson = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return APIResponse(201, RideRecord.fromJson(responseJson['rideRecord']));
    } else {
      return APIResponse(response.statusCode, responseJson);
    }
  }

  Future<APIResponse> deleteRideData(String id) async {
    final response = await client.delete(Uri.parse('$apiDomain/rides/$id'));

    if (response.statusCode == 200) {
      return APIResponse(200, true);
    } else {
      return APIResponse(response.statusCode, false);
    }
  }
}
