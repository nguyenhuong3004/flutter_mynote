import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynote/src/models/note.dart';
import 'package:mynote/src/models/user.dart';
import 'package:mynote/src/routing/route_names.dart';
import 'package:mynote/src/services/auth_service.dart';
import 'package:mynote/src/services/database_service.dart';
import 'package:mynote/src/services/navigation_service.dart';
import 'package:mynote/src/services/prefs_service.dart';

import 'package:mynote/src/viewModel/user_view_model.dart';

import 'package:provider/provider.dart';

import '../../locator.dart';
import 'package:mynote/src/utils/ui_utils.dart';

class Home extends StatelessWidget {
  HomePage() {
    _verifyLogin();
  }

//kiem tra trang thai dang nhap
  void _verifyLogin() async {
    final isLoggedIn = await locator<AuthService>().isUserLoggedIn();
    if (!isLoggedIn)
      locator<NavigationService>().navigateToClearStack(loginRoute);
  }

//lay thong tin user
  void _fetchUserData(BuildContext context) async {
    Provider.of<UserViewModel>(context, listen: false)
        .setUser(locator<PrefsService>().userData);
    final userId = locator<AuthService>().firebaseUser.uid;
    locator<DatabaseService>().getUser(userId).then((value) {
      locator<PrefsService>().userData = User.fromJson(value.data);
      Provider.of<UserViewModel>(context, listen: false).user =
          locator<PrefsService>().userData;
    }).catchError((_) => {});
  }

  void _signOut(BuildContext context) {
    locator<AuthService>().signOut().then((value) {
      locator<NavigationService>().navigateToClearStack(loginRoute);
      locator<PrefsService>().clearAllData();
    }).catchError((e) => {showMessage(context, e.toString())});
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget remindButton = FlatButton(
      child: Text("Không"),
      color: Color.fromARGB(222, 14, 13, 19),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget launchButton = FlatButton(
      child: Text("Có"),
      onPressed: () {
        _signOut(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Lưu ý"),
      content: Text("Bạn có thật sự muốn thoát?"),
      actions: [
        remindButton,
        launchButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _fetchUserData(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => locator<NavigationService>().navigateTo(addNoteRoute),
      ),
      body: SafeArea(child: HomePageLayout()),
      appBar: AppBar(
        elevation: 0,
        //lay thong tin user tu provider
        title: Consumer<UserViewModel>(
          builder: (_, userBloc, child) => Text(
            '${userBloc.user?.displayName ?? 'No name'}\'s Notes',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => showAlertDialog(context),
            icon: Icon(Icons.power_settings_new),
          )
        ],
      ),
    );
  }
}

class HomePageLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: NoteList(),
    );
  }
}

class NoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = locator<AuthService>().firebaseUser.uid;
    return StreamBuilder<QuerySnapshot>(
        stream: locator<DatabaseService>().getNotes(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: new Text('Loading...'));
            default:
              final List<Note> noteList =
                  snapshot.data.documents.map((document) {
                return Note.fromJson(document.data);
              }).toList();
              if (noteList.isEmpty)
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.sentiment_dissatisfied,
                        size: 40,
                      ),
                      Text(
                        'Nothing Here',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                );
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, i) => NoteView(noteList[i]),
                itemCount: noteList.length,
              );
          }
        });
  }
}

class NoteView extends StatelessWidget {
  final Note _note;

  NoteView(this._note);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        //toi trang edit note
        locator<NavigationService>().navigateTo(
          editNoteRoute,
          argument: Note.copy(_note),
        )
      },
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromARGB(255, 255, 255, 255),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 2),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _note.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              //Todo: Improve this
              _note.message,
              overflow: TextOverflow.fade,
              softWrap: true,
              maxLines: 7,
            ),
          ],
        ),
      ),
    );
  }
}
