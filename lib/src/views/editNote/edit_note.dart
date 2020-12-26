import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mynote/src/locator.dart';
import 'package:mynote/src/models/note.dart';
import 'package:mynote/src/views/editNote/edit_note_view_model.dart';
import 'package:mynote/src/services/auth_service.dart';
import 'package:mynote/src/services/database_service.dart';
import 'package:mynote/src/services/navigation_service.dart';
import 'package:mynote/src/utils/ui_utils.dart';
import 'package:provider/provider.dart';

class EditNote extends StatelessWidget {
  final _editNoteViewModel = EditNoteViewModel();

  @override
  Widget build(BuildContext context) {
    final Note _note =
        ModalRoute.of(context).settings.arguments ?? Note.newEmptyNote();
    _editNoteViewModel.setNote(_note);
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider<EditNoteViewModel>.value(
          value: _editNoteViewModel,
          child: NotePageLayout(),
        ),
      ),
      //lưu ghi chú
      floatingActionButton: Builder(
        builder: (builderContext) => FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () => _saveNote(builderContext),
        ),
      ),
      //Xóa ghi chú
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          Builder(
            builder: (buildContext) => IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => showAlertDialog(buildContext),
            ),
          ),
        ],
      ),
    );
  }

//promp user xac nhan xoa
  showAlertDialog(BuildContext context) {
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
        Navigator.of(context).pop();
        _deleteNote(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Lưu ý"),
      content: Text("Bạn có thật sự muốn xóa?"),
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

  void _saveNote(BuildContext context) {
    showProgress(context, 'Lưu ghi chú');
    final userId = locator<AuthService>().firebaseUser.uid;

    locator<DatabaseService>()
        .addOrUpdateNote(userId, _editNoteViewModel.note)
        .then((value) => locator<NavigationService>().goBack())
        .catchError((e) => showMessage(context, e.toString()));
  }

  void _deleteNote(BuildContext context) {
    showProgress(context, 'Xóa ghi chú');
    final userId = locator<AuthService>().firebaseUser.uid;

    locator<DatabaseService>()
        .deleteNote(userId, _editNoteViewModel.note)
        .then((value) => locator<NavigationService>().goBack())
        .catchError((e) => showMessage(context, e.toString()));
  }
}

class NotePageLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editNoteViewModel = Provider.of<EditNoteViewModel>(context);
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            TextField(
              controller:
                  TextEditingController(text: editNoteViewModel.note.title),
              onChanged: (text) => editNoteViewModel.setNoteValue(title: text),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration.collapsed(hintText: 'Tiêu đề'),
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Expanded(
              child: TextField(
                controller:
                    TextEditingController(text: editNoteViewModel.note.message),
                onChanged: (text) =>
                    editNoteViewModel.setNoteValue(message: text),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration.collapsed(hintText: 'Nội dung'),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
