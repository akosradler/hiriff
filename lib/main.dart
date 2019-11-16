import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiriff/HomeScreen.dart';

void main() => runApp(new MediaQuery(
    data: new MediaQueryData(), child: new MaterialApp(home: new MyApp())));

class MyApp extends StatelessWidget {
  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }

}