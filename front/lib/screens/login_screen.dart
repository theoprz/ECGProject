import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:front/classes/ECG_class.dart';

import '../main.dart';
import '../widgets/tag_selection_page.dart'; // Assurez-vous d'importer la page de test

class LoginScreen extends StatelessWidget {
  final CameraDescription camera;
  final FlutterAppAuth appAuth = const FlutterAppAuth();

  const LoginScreen({super.key, required this.camera});


  Future<String?> login(BuildContext context) async {
    try {
      final authorizationTokenRequest = AuthorizationTokenRequest(
        'J7UAkvh3AIeeMd94rLgaCIMqSFHWqLru8vCwzGXp',
        'http://173.212.207.124:3333/api/v1/auth/callback',
        clientSecret: 'QFLECAnm0qf5HeooIhImy44JUIEwRmtzOcMGFWRTvChaLNpgAlb4G9PmdsuRjmeho6zhe3eR9E3rGlS9lBqiBv9eaWTes0RUwyFL7TyeqJB1tpBywuFwEZP1nAoV4ger',
        issuer: 'https://login-demo.uness.fr/oauth',
        discoveryUrl: 'https://login-demo.uness.fr/oauth/.well-known/openid-configuration/',
        scopes: ['openid', 'read', 'write'],
      );

      final AuthorizationTokenResponse? result =
      await appAuth.authorizeAndExchangeCode(
        authorizationTokenRequest,
      );

      print('Resultats de la connexion: ${result?.accessToken}');
      http.Client().close();
      return result?.tokenType;

    } on PlatformException catch (e) {
      print('Login error: $e');
    } catch (e, s) {
      print('Login Uknown error: $e, $s');
      // Gérer les erreurs
    }
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
              onPressed: () {
                login(context).then((value) {
                  if (value != null) {
                    Navigator.pushAndRemoveUntil(//On va sur l'écran d'accueil, on supprime toutes les routes précédentes pour éviter de revenir en arrière
                      context,
                      MaterialPageRoute(//On créer une nouvelle racine,
                        builder: (context) => MyHomePage(title: 'ECG APP', camera: camera),
                        settings: RouteSettings(name: '/'), //Définit la route vers la racine
                      ),
                          (Route<dynamic> route) => false,
                    );
                  } else {
                    // Gérer les erreurs ou les cas d'annulation
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ReceiveCodeAndStatePage extends StatelessWidget {
  final String code;
  final String state;

  const ReceiveCodeAndStatePage({
    Key? key,
    required this.code,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Code et État'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Code: $code'),
            Text('État: $state'),
            // Ajoutez ici la logique pour traiter les données récupérées
          ],
        ),
      ),
    );
  }
}
