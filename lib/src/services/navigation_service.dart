import 'package:flutter/cupertino.dart';

// Lop su dung de di chuyen giua cac view
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  //day view tiep theo len
  Future<dynamic> navigateTo(String routeName, {dynamic argument}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: argument);
  }

  //chuyen view moi
  Future<dynamic> navigateToClearStack(String routeName) {
    return navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeName, (r) => false);
  }

  bool goBack() {
    if (navigatorKey.currentState.canPop()) {
      navigatorKey.currentState.pop();
      return true;
    } else {
      return false;
    }
  }
}
