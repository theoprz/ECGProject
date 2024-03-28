import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/screens/home_screen.dart';
import 'package:marquee/marquee.dart';

import '../classes/ECG_class.dart';

class ECGDisplayer extends StatelessWidget {
  final ECG ecg;

  ECGDisplayer({required this.ecg});

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
              Text(ecg.title ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(ecg.description ?? ''),
              SizedBox(height: 10),
              Text("Age: ${ecg.patientAge ?? ''}"),
              SizedBox(height: 10),
              Text("Sex: ${ecg.patientSex ?? ''}"),
              SizedBox(height: 10),
              Container(
                height: 50,
                child: Marquee(
                  text: ecg.getStringOfAllTags(),
                  style: TextStyle(fontSize: 14),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 20.0,
                  velocity: 50.0,
                  startPadding: 10.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}