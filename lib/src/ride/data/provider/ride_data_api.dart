import 'dart:convert';

import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';

import 'package:trailbrake/src/ride/data/data.dart';

// DEV ONLY
// import 'dart:io';

class RideDataAPI {
  final String apiDomain = 'https://driverapp-2022.de.r.appspot.com';
  http.Client client = http.Client();

  Future<List<RideMeta>> fetchRideCatalog() async {
    final response = await client.get(Uri.parse('$apiDomain/rides'));

    final List<RideMeta> allRideHistory = <RideMeta>[];

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      responseBody.forEach((element) {
        allRideHistory.add(RideMeta.fromJson(element));
      });

      return allRideHistory;
    } else {
      throw Exception(
          'Failed to find data with the following error: ${response.body}');
    }
  }

  Future<Ride> fetchRideData(String id) async {
    final response = await client.get(Uri.parse('$apiDomain/rides/$id'));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      return Ride.fromJson(responseBody);
    } else {
      throw Exception(
          'Failed to find data with the following error: ${response.body}');
    }
  }

  Future<bool> saveRideData(Ride postBody) async {
    // FOR DEVELOPMENT ONLY
    // PermissionStatus status = await Permission.storage.request();
    // while (status != PermissionStatus.granted) {
    //   status = await Permission.storage.request();
    // }

    // final directory = Directory('/storage/emulated/0/Download');
    // final file = File(
    //     '${directory.path}/driverapp_data_${postBody.rideName}_${postBody.rideDate.toString()}.txt');
    // file.writeAsString(jsonEncode(postBody));

    final response = await client.post(
      Uri.parse('$apiDomain/rides'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(postBody),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
          'Failed to POST data with the following error: ${response.body}');
    }
  }
}
