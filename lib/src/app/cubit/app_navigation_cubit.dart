import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_navigation_state.dart';

class AppNavigationCubit extends Cubit<AppNavigationState> {
  AppNavigationCubit() : super(AppNavigationInitial());

  void viewDashboard() {
    emit(AppNavigationLoadDashboardSuccess());
  }

  void startRide() {
    emit(AppNavigationStartRideSuccess());
  }

  void viewProfile() {
    emit(AppNavigationLoadProfileSuccess());
  }
}
