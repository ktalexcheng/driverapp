import 'package:flutter_bloc/flutter_bloc.dart';

class DebugBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    print('${bloc.runtimeType} $change');
    super.onChange(bloc, change);
  }
}
