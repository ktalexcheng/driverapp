import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_navigation_state.dart';

class AppNavigationCubit extends Cubit<AppNavigationState> {
  AppNavigationCubit() : super(AppNavigationInitial());

  void viewDashboard() {
    emit(AppNavigationLoadDashboardSuccess());
  }

  void newRideActivity() {
    emit(AppNavigationLoadRideSuccess());
  }

  void viewProfile() {
    emit(AppNavigationLoadProfileSuccess());
  }
}
