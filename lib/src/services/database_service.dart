import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote/src/models/note.dart';
import 'package:mynote/src/models/user.dart';

//lop ket noi toi firestore
class DatabaseService {
  final Firestore _database = Firestore.instance;

  static const _USERS = 'users';
  static const _NOTES = 'notes';

  Future<void> addOrUpdateUser(User user) async {
    return _database
        .collection(_USERS)
        .document(user.userId)
        .setData(user.toMap());
  }

  Future<DocumentSnapshot> getUser(String userId) async {
    return _database.collection(_USERS).document(userId).get();
  }

  Stream<QuerySnapshot> getNotes(String userId) async* {
    //thong tin ghi chu duoc update realtime
    yield* _database
        .collection(_USERS)
        .document(userId)
        .collection(_NOTES)
        .snapshots();
  }

  Future<void> addOrUpdateNote(String userId, Note note) async {
    return _database
        .collection(_USERS)
        .document(userId)
        .collection(_NOTES)
        .document(note.noteId)
        .setData(note.toMap());
  }

  Future<void> deleteNote(String userId, Note note) async {
    return _database
        .collection(_USERS)
        .document(userId)
        .collection(_NOTES)
        .document(note.noteId)
        .delete();
  }
}
