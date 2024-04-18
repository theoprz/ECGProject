import 'package:auth0_flutter_platform_interface/src/credentials.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:front/screens/Profile/components/contact_screen.dart';
import 'package:front/screens/login_screen.dart';
import 'components/compte_screen.dart';
import 'components/informations_screen.dart';
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';
class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  final CameraDescription camera;
  final Credentials credentials;

  ProfileScreen({super.key, required this.camera, required this.credentials});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
           const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Mon compte",
              icon: "assets/icons/User Icon.svg",
              next: const Icon(Icons.navigate_next),
              press: () => {
                Navigator.push(context,MaterialPageRoute(builder:(context)=> CompteScreen(credentials: credentials)) )
              },
            ),
            ProfileMenu(
              text: "À propos",
              icon: "assets/icons/Question mark.svg",
              next: const Icon(Icons.navigate_next),
              press: () {
                 Navigator.push(context,MaterialPageRoute(builder:(context)=> const InformationScreen()) );
              },
            ),
            ProfileMenu(
              text: "Nous contacter",
              icon: "assets/icons/Mail.svg",
              next: const Icon(Icons.navigate_next),
              press: () async {
                Navigator.push(context,MaterialPageRoute(builder:(context)=> const ContactScreen()) );
                },
            ),
             ProfileMenu2(
              text: "Déconnexion",
              icon: "assets/icons/Log out.svg",
              press: () {
                Navigator.pushAndRemoveUntil(//On va sur l'écran d'accueil, on supprime toutes les routes précédentes pour éviter de revenir en arrière
                  context,
                  MaterialPageRoute(//On créer une nouvelle racine,
                    builder: (context) => LoginScreen(camera: camera,),
                    settings: RouteSettings(name: '/'), //Définit la route vers la racine
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