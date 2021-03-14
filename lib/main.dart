import 'package:farm_animals_manager/screens/auth/Auth.dart';
import 'package:flutter/material.dart';
import 'package:farm_animals_manager/screens/HomePage.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FarmManager());
}

class FarmManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Farm Animals Manager - Manish",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      home: AuthScreen(),
    );
  }
}
