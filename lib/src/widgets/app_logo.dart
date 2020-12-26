import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: CircleAvatar(child: Image.asset('assets/note-icon-04.png')),
    );
  }
}
