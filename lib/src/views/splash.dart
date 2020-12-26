import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynote/src/locator.dart';
import 'package:mynote/src/routing/route_names.dart';
import 'package:mynote/src/services/auth_service.dart';
import 'package:mynote/src/services/prefs_service.dart';
import 'package:mynote/src/services/navigation_service.dart';
import 'package:mynote/src/widgets/app_logo.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _navigate(context);
    return Scaffold(
      body: Center(
        child: AppLogo(),
      ),
    );
  }

  void _navigate(BuildContext context) async {
    //dung manh hinh tao hieu ung load
    await Future.delayed(const Duration(milliseconds: 1000));
    final isLoggedIn = await locator<AuthService>().isUserLoggedIn();
    isLoggedIn
        ? locator<NavigationService>().navigateToClearStack(homeRoute)
        : {
            locator<PrefsService>().clearAllData(),
            locator<NavigationService>().navigateToClearStack(loginRoute)
          };
  }
}
