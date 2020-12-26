import 'package:flutter/foundation.dart';
import 'package:mynote/src/models/user.dart';

//user view thay doi neu data thay doi ma khong can setstate
class UserViewModel extends ChangeNotifier {
  User _user;

  User get user => _user;

  set user(User user) {
    _user = user;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
  }
}
