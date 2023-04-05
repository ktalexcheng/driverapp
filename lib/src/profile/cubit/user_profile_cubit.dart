import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:trailbrake/src/profile/data/data.dart';
import 'package:trailbrake/src/common/common.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());

  final ProfileAPI _profileClient = ProfileAPI();
  final AuthenticationRepository _authRepository = AuthenticationRepository();

  void getUserProfileData() async {
    emit(UserProfileGetInProgress());

    if (!(await _authRepository.isAuthenticated())) {
      emit(UserProfileUnauthenticated());
      return;
    }

    ProfileAPIResponse response = await _profileClient.getUserProfile();

    if (response.httpCode == 200) {
      emit(UserProfileGetSuccess(user: response.responseBody));
    } else {
      emit(UserProfileGetFailure());
    }
  }

  void guestMode() async {
    emit(UserProfileUnauthenticated());
  }
}
