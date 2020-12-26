import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mynote/src/locator.dart';
import 'package:mynote/src/routing/route_names.dart';
import 'package:mynote/src/services/auth_service.dart';
import 'package:mynote/src/services/navigation_service.dart';
import 'package:mynote/src/utils/ui_utils.dart';
import 'package:mynote/src/widgets/app_logo.dart';
import 'package:mynote/src/widgets/custom_text_field.dart';
import 'package:mynote/src/widgets/scrollable_centerd_sized_box.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPageLayout(),
    );
  }
}

class LoginPageLayout extends StatefulWidget {
  @override
  _LoginPageLayoutState createState() => _LoginPageLayoutState();
}

class _LoginPageLayoutState extends State<LoginPageLayout> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ScrollableCenteredSizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppLogo(),
            SizedBox(height: 30),
            SizedBox(height: 30),
            CustomTextField(
              controller: _emailTextController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
            SizedBox(height: 8),
            CustomTextField(
              controller: _passwordTextController,
              obscureText: true,
              labelText: 'Password',
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _verifyLogin(),
            ),
            SizedBox(height: 8),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: MaterialButton(
                color: Theme.of(context).accentColor,
                onPressed: () => _verifyLogin(),
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text('hoặc'),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: MaterialButton(
                  color: Colors.white,
                  onPressed: () {
                    locator<NavigationService>().navigateTo(registerRoute);
                  },
                  child: Text(
                    'Đăng ký',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyLogin() {
    String email = _emailTextController.text.trim();
    String password = _passwordTextController.text.trim();
    showProgress(context, 'Đăng nhập...');
    locator<AuthService>()
        .loginUser(email, password)
        .then((value) =>
            {locator<NavigationService>().navigateToClearStack(homeRoute)})
        .catchError((e) => {
              hideProgress(context),
              (e is PlatformException)
                  ? showMessage(context, e.message)
                  : showMessage(context, e.toString())
            });
  }
}
