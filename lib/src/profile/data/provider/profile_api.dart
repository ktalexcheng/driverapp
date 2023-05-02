import 'dart:convert';

import 'package:trailbrake/src/profile/data/model/model.dart';
import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class ProfileAPIResponse {
  ProfileAPIResponse(this.httpCode, this.responseBody);

  final int httpCode;
  dynamic responseBody;
}

class ProfileAPI {
  final String apiDomain = constants.trailbrakeApiUrl;
  AuthorizedHttpClient client = AuthorizedHttpClient();

  Future<ProfileAPIResponse> getUserProfile() async {
    RideScore userScore;
    UserLifetimeStats userStats;
    final Map<String, dynamic> userInfo;

    final responseInfo = await client.get(Uri.parse('$apiDomain/profile/info'));
    if (responseInfo.statusCode == 200) {
      userInfo = jsonDecode(responseInfo.body);
    } else {
      return ProfileAPIResponse(responseInfo.statusCode, responseInfo.body);
    }

    final responseScore =
        await client.get(Uri.parse('$apiDomain/profile/score'));
    if (responseScore.statusCode == 200) {
      userScore = RideScore.fromJson(jsonDecode(responseScore.body));
    } else {
      return ProfileAPIResponse(responseScore.statusCode, responseScore.body);
    }

    final responseStat =
        await client.get(Uri.parse('$apiDomain/profile/stats'));
    if (responseStat.statusCode == 200) {
      userStats = UserLifetimeStats.fromJson(jsonDecode(responseStat.body));
    } else {
      return ProfileAPIResponse(responseStat.statusCode, responseStat.body);
    }

    RegisteredUser user = RegisteredUser(
      userId: userInfo["userAlias"],
      username: userInfo["userAlias"],
      scores: userScore,
      stats: userStats,
    );

    return ProfileAPIResponse(200, user);
  }
}
