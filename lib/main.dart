import 'package:flutter/material.dart';
import 'package:jester_travel/screens/firstScreen.dart';
import 'package:jester_travel/screens/secondScreen.dart';

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => FirstScreen(),
       '/secondScreen': (BuildContext context) => SecondScreen(''),
       
      }));
}
