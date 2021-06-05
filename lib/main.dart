import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:imemo_mobile/screens/first_screen.dart';
import 'package:imemo_mobile/screens/signin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initializeFlutterFire() async {
    await Firebase.initializeApp();
  }
  
  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iMemo',
      theme: new ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Color(0xff440888)
      ),
      home: FirstScreen(),
    );
  }
}