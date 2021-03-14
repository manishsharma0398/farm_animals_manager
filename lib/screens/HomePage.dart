import 'package:farm_animals_manager/components/Drawer.dart';
import 'package:farm_animals_manager/screens/dashboard/Dashboard.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO::
      // body: Container(
      //   child: Text("if not logged in show login page else show dashboard"),
      // ),
      body: Dashboard(),
    );
  }
}
