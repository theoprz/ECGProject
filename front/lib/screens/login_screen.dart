import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/classes/ECG_class.dart';

import '../main.dart';
import '../widgets/tag_selection_page.dart'; // Assurez-vous d'importer la page de test

class LoginScreen extends StatelessWidget {
  final CameraDescription camera;

  const LoginScreen({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('Connexion'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(title: 'ECG APP', camera: camera),
                  ),
                );
              },
            ),
            MaterialButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('Page de test'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TagSelectionPage(ecg: new ECG("Titre", "Description", 0, "Masculin", [], 0)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}