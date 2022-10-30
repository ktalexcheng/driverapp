import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:trailbrake/src/profile/data/data.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());

  ProfileAPI profileClient = ProfileAPI();

  void getUserProfileData() async {
    emit(UserProfileGetInProgress());

    ProfileAPIResponse response = await profileClient.getUserProfile();

    if (response.httpCode == 200) {
      emit(UserProfileGetSuccess(user: response.responseBody));
    } else {
      emit(UserProfileGetFailure());
    }
  }
}
