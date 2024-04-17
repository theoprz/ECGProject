import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:front/widgets/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            itemProfile2("Nous sommes des étudiants de Junia ISEN Lille et sommes heureux d'avoir travaillé sur ce projet. Vous pouvez nous joindre avec les informations ci-dessous:"),
             const SizedBox(height: 30),
            ProfileMenu4(
              text: "GitHUB",
              subtitle: "https://github.com/theoprz/ECGProject",
              icon: "assets/icons/Github.svg",
              press: () {
               launchUrl(Uri.parse('https://github.com/theoprz/ECGProject'));
               final Uri _url = Uri.parse('https://flutter.dev');
               Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
               
              } 
              },
            ),
            ProfileMenu4(
              text: "Mail",
              subtitle:"theo.porzio@student.junia.com",
              icon: "assets/icons/Mail.svg",
              press: (){
                String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
// ···
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'theo.porzio@student.junia.com',
    query: encodeQueryParameters(<String, String>{
    }),
  );
  launchUrl(emailLaunchUri);
              },
            ),
            ProfileMenu4(
              text: "localisation",
              subtitle: "40 Boulevard Vauban, 59000 Lille",
              icon: "assets/icons/Location.svg",
              press: () {
                },
            ),
          ],
        ),
      ),
    );
  }
}

  itemProfile2(String subtitle) {
    return Container(
      child: ListTile(
        subtitle: Text(subtitle,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,)),
        tileColor: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }

class ProfileMenu4 extends StatelessWidget {
  final String text;
  final String subtitle; // Nouveau champ pour le sous-titre
  final String icon;
  final VoidCallback? press;

  const ProfileMenu4({
    Key? key,
    required this.text,
    required this.subtitle,
    required this.icon,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
          padding: const EdgeInsets.all(30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color.fromARGB(255, 240, 240, 240),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: kPrimaryColor,
              width: 22,
            ),
            const SizedBox(width: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 164, 164, 164)),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}