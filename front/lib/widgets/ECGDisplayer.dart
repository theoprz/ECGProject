import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/screens/home_screen.dart';

class ECGDisplayer extends StatelessWidget {
  final ExampleObject exampleObject;

  ECGDisplayer({required this.exampleObject});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95 , // Set the width to the value you want
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(exampleObject.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(exampleObject.description),
            ],
          ),
        ),
      ),
    );
  }
}