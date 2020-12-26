import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynote/src/locator.dart';
import 'package:mynote/src/routing/route_names.dart';
import 'package:mynote/src/routing/router.dart';
import 'package:mynote/src/services/navigation_service.dart';

import 'package:mynote/src/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //tao provider de goi thong tin user trong child widget
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: Consumer<UserViewModel>(
        builder: (buildContext, value, child) {
          return MaterialApp(
            title: "MyNote",
            onGenerateRoute: generateRoute,
            navigatorKey: locator<NavigationService>().navigatorKey,
            initialRoute: splashRoute,
          );
        },
      ),
    );
  }
}
