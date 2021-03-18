import 'package:flutter/material.dart';

PopupMenuItem<String> buildPopupMenuItem(
    {String menuText, String menuValue, IconData menuIcon}) {
  return PopupMenuItem(
    value: "$menuValue",
    child: Row(
      children: [
        Icon(
          menuIcon,
          color: Colors.black,
        ),
        SizedBox(width: 10),
        Text("$menuText"),
      ],
    ),
  );
}
