import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/ECG_class.dart';
import '../widgets/TagDisplayer.dart'; // Assurez-vous d'importer TagDisplayer

class ECGDetailsPage extends StatelessWidget {
  final ECG ecg;

  const ECGDetailsPage({Key? key, required this.ecg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('${ecg.title}'),
      ),
      body: Center(
        child: Container(
          color: Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Description: ${ecg.description}'),
              Text('Patient Age: ${ecg.patientAge}'),
              Text('Patient Sex: ${ecg.patientSex}'),
              Expanded(
                child: ListView.separated(
                  itemCount: ecg.tags.length,
                  itemBuilder: (context, index) {
                    return TagDisplayer(tag: ecg.tags[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}