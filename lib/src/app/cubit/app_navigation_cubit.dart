import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_navigation_state.dart';

class AppNavigationCubit extends Cubit<AppNavigationState> {
  AppNavigationCubit() : super(AppNavigationInitial());

  void viewHistory() {
    emit(AppNavigationLoadHistorySuccess());
  }

  void startNewRide() {
    emit(AppNavigationStartNewRideSuccess());
  }
}
