import 'package:flutter/material.dart';

class AddEcgScreen extends StatefulWidget {
  const AddEcgScreen({Key? key}) : super(key: key);

  @override
  _AddEcgScreenState createState() => _AddEcgScreenState();
}

class _AddEcgScreenState extends State<AddEcgScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ECG Screen'),
      ),
      body: Center(
        child: Text('Welcome to the Add ECG Screen!'),
      ),
    );
  }
}