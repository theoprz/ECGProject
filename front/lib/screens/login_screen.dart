import 'dart:io';

import 'package:camera/camera.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:front/classes/ECG_class.dart';

import '../main.dart';
import '../widgets/tag_selection_page.dart'; // Assurez-vous d'importer la page de test

class LoginScreen extends StatefulWidget {
  final CameraDescription camera;
  const LoginScreen({super.key, required this.camera});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late CameraDescription camera;
  Credentials? _credentials;
  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    camera = widget.camera;
    auth0 = Auth0('dev-hbsfg1yxwpptxje3.us.auth0.com', 'IJuREpvILlb3zxgNKoazrkeP9aPAaMfj');
  }

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
                onPressed: () async => {
                  _credentials = await auth0.webAuthentication(scheme: "com.group40.front").login(useHTTPS: true),
                  Navigator.pushAndRemoveUntil(
                  //On va sur l'écran d'accueil, on supprime toutes les routes précédentes pour éviter de revenir en arrière
                    context,
                    MaterialPageRoute(
                    //On créer une nouvelle racine,
                    builder: (context) =>
                      MyHomePage(title: 'ECG APP', camera: camera, credentials: _credentials!),
                      settings: RouteSettings(
                      name: '/'), //Définit la route vers la racine
                    ),
                    (Route<dynamic> route) => false,
                )
            }),
            MaterialButton(
              color: Colors.red.shade900,
              textColor: Colors.white,
              child: Text('AUTH BYPASS'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  //On va sur l'écran d'accueil, on supprime toutes les routes précédentes pour éviter de revenir en arrière
                  context,
                  MaterialPageRoute(
                    //On créer une nouvelle racine,
                    builder: (context) =>
                        MyHomePage(title: 'ECG APP', camera: camera, credentials: _credentials!),
                    settings: RouteSettings(
                        name: '/'), //Définit la route vers la racine
                  ),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
