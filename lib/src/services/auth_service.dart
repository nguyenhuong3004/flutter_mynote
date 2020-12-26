import 'package:firebase_auth/firebase_auth.dart';

//Lop chua cac phuong thuc lien quan toi authen
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;

  FirebaseUser get firebaseUser => _firebaseUser;

  Future<bool> isUserLoggedIn() async {
    _firebaseUser ??= await _auth.currentUser();
    return _firebaseUser != null;
  }

  Future<FirebaseUser> loginUser(String email, String password) async {
    var result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    _firebaseUser = result.user;
    return _firebaseUser;
  }

  Future<FirebaseUser> registerUser(String email, String password) async {
    var result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    _firebaseUser = result.user;
    return _firebaseUser;
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}
