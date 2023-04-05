part of 'user_auth_cubit.dart';

@immutable
abstract class UserAuthState {}

class UserAuthInitial extends UserAuthState {}

class UserAuthLoginInProgress extends UserAuthState {}

class UserAuthLoginSuccess extends UserAuthState {}

class UserAuthLoginFailed extends UserAuthState {}

class UserAuthLogoutInProgress extends UserAuthState {}

class UserAuthLogoutSuccess extends UserAuthState {}

class UserAuthLogoutFailed extends UserAuthState {}

class UserAuthCreateInProgress extends UserAuthState {}

class UserAuthCreateSuccess extends UserAuthState {}

class UserAuthCreateFailed extends UserAuthState {}
