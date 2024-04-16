import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:front/classes/ECG_class.dart';

import '../main.dart';
import '../widgets/tag_selection_page.dart'; // Assurez-vous d'importer la page de test

class LoginScreen extends StatelessWidget {
  final CameraDescription camera;
  final FlutterAppAuth appAuth = const FlutterAppAuth();

  const LoginScreen({super.key, required this.camera});


  Future<String> login() async {
    try {
      final authorizationTokenRequest = AuthorizationTokenRequest(
        'J7UAkvh3AIeeMd94rLgaCIMqSFHWqLru8vCwzGXp',
        'http://173.212.207.124:3333/api/v1/ecg',
        clientSecret: 'QFLECAnm0qf5HeooIhImy44JUIEwRmtzOcMGFWRTvChaLNpgAlb4G9PmdsuRjmeho6zhe3eR9E3rGlS9lBqiBv9eaWTes0RUwyFL7TyeqJB1tpBywuFwEZP1nAoV4ger',
        issuer: 'https://login-demo.uness.fr/oauth',
        discoveryUrl: 'https://login-demo.uness.fr/oauth/.well-known/openid-configuration/',
        scopes: ['openid', 'read', 'write'],
      );

      final AuthorizationTokenResponse? result =
      await appAuth.authorizeAndExchangeCode(
        authorizationTokenRequest,
      );

      print("Logged in");
      return "Logged in!";
    } on PlatformException {
      print('error cancel or no internet');
      return 'User has cancelled or no internet!';
    } catch (e, s) {
      print('Login Uknown erorr $e, $s');
      return 'Unkown Error!';
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
              onPressed: () => login(),
            ),
          ],
        ),
      ),
    );
  }
}