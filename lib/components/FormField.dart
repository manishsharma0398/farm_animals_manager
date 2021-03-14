import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  final Widget field;
  final String fieldLabel;

  Field({@required this.field, this.fieldLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fieldLabel != null)
          Text(
            fieldLabel,
            style: TextStyle(fontSize: 18),
          ),
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(9),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: field,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
