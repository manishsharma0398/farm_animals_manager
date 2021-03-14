import 'package:flutter/material.dart';

Future<void> showDialogBox(
  BuildContext ctx, {
  String title,
  String subtitle,
  List<Widget> dialogBoxActions,
  dismissOnClick = false,
}) async {
  return showDialog<void>(
    context: ctx,
    barrierDismissible: dismissOnClick,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(subtitle),
        ),
        actions: dialogBoxActions,
      );
    },
  );
}
