part of 'user_profile_cubit.dart';

@immutable
abstract class UserProfileState {
  RegisteredUser get user;
}

class UserProfileInitial extends UserProfileState {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class UserProfileGetInProgress extends UserProfileState {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class UserProfileGetSuccess extends UserProfileState {
  UserProfileGetSuccess({required this.user});

  @override
  final RegisteredUser user;
}

class UserProfileGetFailure extends UserProfileState {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
