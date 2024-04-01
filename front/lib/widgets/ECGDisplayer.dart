import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../classes/ECG_class.dart';

class ECGDisplayer extends StatelessWidget {
  final ECG ecg;

  const ECGDisplayer({super.key, required this.ecg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95 , // Set the width to the value you want
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(ecg.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(ecg.description),
              const SizedBox(height: 10),
              Text("Age: ${ecg.patientAge}"),
              const SizedBox(height: 10),
              Text("Sex: ${ecg.patientSex}"),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: Marquee(
                  text: ecg.getStringOfAllTags(),
                  style: const TextStyle(fontSize: 14),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 20.0,
                  velocity: 60.0,
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