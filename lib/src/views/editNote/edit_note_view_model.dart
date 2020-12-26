import 'package:flutter/material.dart';
import 'package:mynote/src/models/note.dart';

//note view model
class EditNoteViewModel extends ChangeNotifier {
  Note _note = null;

  Note get note => _note;

  void setNote(Note note) {
    _note = note;
  }

  void setNoteValue({
    String title = null,
    String message = null,
  }) {
    if (title != null) _note.title = title;
    if (message != null) _note.message = message;
  }
}
