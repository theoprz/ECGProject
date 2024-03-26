import 'package:flutter/material.dart';

class parameterScreen extends StatefulWidget {
  const parameterScreen({Key? key}) : super(key: key);

  @override
  _parameterScreenState createState() => _parameterScreenState();
}

class _parameterScreenState extends State<parameterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parameter Screen'),
      ),
      body: Center(
        child: Text('Welcome to the parameter Screen!'),
      ),
    );
  }
}