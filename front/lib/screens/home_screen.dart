import 'package:flutter/material.dart';
import 'package:front/widgets/ECGDisplayer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ExampleObject> items = List<ExampleObject>.generate(100, (i) => ExampleObject("Titre $i", "Description $i")); //Génère une liste de 100 objets pour l'exemple

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
          return ECGDisplayer(exampleObject: items[index]);
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 10);
        },
      ),
    );
  }
}


class ExampleObject {
  final String title;
  final String description;

  ExampleObject(this.title, this.description);
}