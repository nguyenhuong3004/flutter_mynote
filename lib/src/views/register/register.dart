import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mynote/src/models/note.dart';
import 'package:mynote/src/models/user.dart';

import 'package:mynote/src/routing/route_names.dart';
import 'package:mynote/src/services/auth_service.dart';
import 'package:mynote/src/services/database_service.dart';
import 'package:mynote/src/services/navigation_service.dart';
import 'package:mynote/src/utils/ui_utils.dart';
import 'package:mynote/src/widgets/app_logo.dart';
import 'package:mynote/src/widgets/custom_text_field.dart';
import 'package:mynote/src/widgets/scrollable_centerd_sized_box.dart';

import '../../locator.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterLayout(),
    );
  }
}

class RegisterLayout extends StatefulWidget {
  @override
  _RegisterLayoutState createState() => _RegisterLayoutState();
}

class _RegisterLayoutState extends State<RegisterLayout> {
  final _nameTextController = TextEditingController();
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
            Text('Đăng ký', style: TextStyle(fontSize: 20)),
            SizedBox(height: 30),
            AppLogo(),
            SizedBox(height: 30),
            CustomTextField(
              controller: _nameTextController,
              labelText: 'Tên',
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
            SizedBox(height: 8),
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
              onSubmitted: (_) => _registerUser(),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: MaterialButton(
                color: Theme.of(context).accentColor,
                onPressed: () => _registerUser(),
                child: Text(
                  'Đăng ký',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registerUser() {
    String name = _nameTextController.text.trim();
    String email = _emailTextController.text.trim();
    String password = _passwordTextController.text.trim();
    showProgress(context, 'Creating Account...');
    locator<AuthService>()
        .registerUser(email, password)
        .then((value) => locator<DatabaseService>().addOrUpdateUser(
              User(
                userId: value.uid,
                displayName: name,
                emailId: email,
              ),
            ))
        .then((value) => {
              locator<DatabaseService>().addOrUpdateNote(
                locator<AuthService>().firebaseUser.uid,
                welcomeNote(),
              ),
              locator<NavigationService>().navigateToClearStack(homeRoute)
            })
        .catchError((e) => {
              (e is PlatformException)
                  ? showMessage(context, e.message)
                  : showMessage(context, e.toString())
            });
  }
}
