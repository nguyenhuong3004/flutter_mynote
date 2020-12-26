import 'package:flutter/foundation.dart';

class User {
  String userId;
  String displayName;
  String emailId;

  User({
    @required this.userId,
    @required this.displayName,
    @required this.emailId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'displayName': displayName,
      'emailId': emailId,
    };
  }

  User.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        displayName = json['displayName'],
        emailId = json['emailId'];
}
