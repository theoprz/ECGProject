import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../classes/ECG_class.dart';
import '../widgets/TagDisplayer.dart';

class ECGDetailsPage extends StatelessWidget {
  final ECG ecg;

  const ECGDetailsPage({Key? key, required this.ecg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: AppBar(
          title: Text('ECG Details'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0), // Set this value to your needed height
            child: Container(
              color: Colors.red,
              child: SingleChildScrollView(
                child: Center(
                  child: Text(' ECG ID : ${ecg.id}'),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          color: Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${ecg.title}'),
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

//TODO ENHANCE TOPBAR