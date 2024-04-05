import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/compte_screen.dart';
import 'components/informations_screen.dart';
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';
class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});
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
                Navigator.push(context,MaterialPageRoute(builder:(context)=> const CompteScreen()) )
              },
            ),
            ProfileMenu(
              text: "Informations",
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
                //TODO :  REDIRIGER VERS UNE PAGE DE CONTACT AVEC UN MAILTO DEDANS
                },
            ),
             ProfileMenu(
              text: "Déconnexion",
              icon: "assets/icons/Log out.svg",
              next: const Icon(Icons.navigate_next),
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}