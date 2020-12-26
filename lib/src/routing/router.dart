import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mynote/src/routing/route_names.dart';
import 'package:mynote/src/views/editNote/edit_note.dart';

import 'package:mynote/src/views/home/home.dart';
import 'package:mynote/src/views/login/login.dart';
import 'package:mynote/src/views/register/register.dart';
import 'package:mynote/src/views/splash.dart';

//ham tao route cho cac view
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashRoute:
      return _getPageRoute(Splash(), settings);
    case homeRoute:
      return _getPageRoute(Home(), settings);
    case loginRoute:
      return _getPageRoute(Login(), settings);
    case registerRoute:
      return _getPageRoute(Register(), settings);

    case addNoteRoute:
      return _getPageRoute(EditNote(), settings);
    case editNoteRoute:
      return _getPageRoute(EditNote(), settings);

    default:
      return _getPageRoute(Splash(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return (MaterialPageRoute(
    settings: settings,
    builder: (context) => child,
  ));
}
