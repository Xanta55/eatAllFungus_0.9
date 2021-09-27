import 'package:hooks_riverpod/hooks_riverpod.dart';

final navStateProvider = StateNotifierProvider<Routes, String>(
  (ref) => Routes(startRoute: 'overview'),
);

class Routes extends StateNotifier<String> {
  Routes({String? startRoute}) : super('') {
    if (startRoute != null) {
      state = startRoute;
    } else {
      state = 'overview';
    }
  }

  void setRoute(input) {
    state = input;
  }

  String getRoute() {
    return state;
  }
}
