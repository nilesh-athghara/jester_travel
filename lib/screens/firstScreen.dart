import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jester_travel/screens/secondScreen.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  String customerId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jester Travel",
            style: TextStyle(fontSize: 18, color: Colors.white)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.blue,
      ),
      body: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Center(
              child: Column(
            children: <Widget>[
              TextField(
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(),
                  labelText: 'user id',
                ),
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                obscureText: false,
                onChanged: (value) {
                  customerId = value;
                },
              ),
              SizedBox(height: 20),
              RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SecondScreen(
                              customerId,
                            )),
                  );
                },
                child: new Text("Submit",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              )
            ],
          ))),
    );
  }
}
