import 'package:flutter/material.dart';
import 'package:front/widgets/ECGDisplayer.dart';

import '../classes/ECG_class.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  /*
  final List<ECG> items = List<ECG>.generate(100, (i) => ECG("Titre $i", "Description $i", 55, 0, [])); //Génère une liste de 100 objets pour l'exemple

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Mes ECG'),
      ),
      body: ListView.separated(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ECGDisplayer(ecg: items[index]);
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 10);
        },
      ),
    );
  }
*/


  late List<ECG> items;

  @override
  void initState() {
    super.initState();
    generateFakeECGList().then((value) => items = value);
  }

  Future<List<ECG>> generateFakeECGList() async {
    List<ECG> ecgList = [];
    for (int i = 0; i < 20; i++) {
      ECG ecg = ECG("Title $i", "Description $i", i, "1", []);
      await ecg.setECGFromJson();
      ecgList.add(ecg);
    }
    return ecgList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: generateFakeECGList(),
      builder: (BuildContext context, AsyncSnapshot<List<ECG>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading spinner while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error message if something went wrong
        } else {
          items = snapshot.data!; // Assign the data to items when it's loaded
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ECGDisplayer(ecg: snapshot.data![index]);
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
          );
        }
      },
    );
  }
}