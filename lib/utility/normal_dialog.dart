import 'package:flutter/material.dart';

Widget okButton(BuildContext context) {
  return FlatButton(
    child: Text('OK'),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
}

Future<void> normalDialog(
    BuildContext context, String title, String message) async {
  showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[okButton(context)],
        );
      });
}
