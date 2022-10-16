import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:trailbrake/src/ride/data/data.dart';

class RideDataAPI {
  final String apiDomain = 'https://driverapp-2022.de.r.appspot.com';
  http.Client client = http.Client();

  Future<APIResponse> fetchRideCatalog() async {
    final response = await client.get(Uri.parse('$apiDomain/rides'));

    final List<RideMeta> allRideHistory = <RideMeta>[];

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      responseBody.forEach((element) {
        allRideHistory.add(RideMeta.fromJson(element));
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

      return APIResponse(200, Ride.fromJson(responseBody));
    } else {
      return APIResponse(response.statusCode, response.body);
    }
  }

  Future<APIResponse> saveRideData(Ride postBody) async {
    final response = await client.post(
      Uri.parse('$apiDomain/rides'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(postBody),
    );

    if (response.statusCode == 201) {
      return APIResponse(201, true);
    } else {
      return APIResponse(response.statusCode, false);
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
