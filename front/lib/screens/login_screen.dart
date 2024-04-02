import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class LoginScreen extends StatelessWidget {
  final CameraDescription camera;

  const LoginScreen({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
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
      ),
    );
  }
}

//TODO: PREVENT USER FROM GOING BACK TO LOGIN SCREEN AFTER LOGGING IN