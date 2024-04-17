import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:front/widgets/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("À propos"),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child:SingleChildScrollView(
        child: Column(
          children: [
            itemProfile3("Cette application a été réalisée dans le cadre de notre projet de M1 à l'ISEN Lille. Nous sommes une équipe de 6 étudiants ingénieurs en informatique."),
            const SizedBox(height: 20),
            ProfileMenu4(
             text: "Théo PORZIO",
             subtitle: "Cliquer pour accéder au profil LinkedIn",
             imagePath: "assets/images/Theo.jpeg",
             press: () {
               launchUrl(Uri.parse("https://www.linkedin.com/in/th%C3%A9o-porzio-6537b11a4/"));
              },
              titleSize: 22,
             ),
            const SizedBox(height: 20),
            ProfileMenu4(
              text: "Aurélien ROGÉ",
             subtitle: "Cliquer pour accéder au profil LinkedIn",
             imagePath: "assets/images/Aurelien.jpeg",
             press: () {
               launchUrl(Uri.parse("www.linkedin.com/in/aurelienroge"));
              },
              titleSize: 22,
             ),
            const SizedBox(height: 20),
            ProfileMenu4(
              text: "Alexandre DEPREZ",
            subtitle: "Cliquer pour accéder au profil LinkedIn",
            imagePath:"assets/images/ALEXANDRE.jpeg",
             press: () {
               launchUrl(Uri.parse("https://www.linkedin.com/in/alexandre-deprez/"));
              },
              titleSize: 22,
            ),
            const SizedBox(height: 20),
            ProfileMenu4(
              text: "Melchior AHOLOU",
            subtitle: "Cliquer pour accéder au profil LinkedIn",
            imagePath:"assets/images/Melchior.JPG",
            press: () {
              launchUrl(Uri.parse("https://www.linkedin.com/in/melchior-aholou/"));
              },
              titleSize: 22,
            ),
            const SizedBox(height: 20),
            ProfileMenu4(
              text: "Paul MAERTEN",
              subtitle: "Cliquer pour accéder au profil LinkedIn",
              imagePath: 'assets/images/img_avatar.png',
              press: () {
                launchUrl(Uri.parse('https://www.linkedin.com/in/paul-maerten-a8876b20b/'));
              },
              titleSize: 22,
            ),
            const SizedBox(height: 20),
             ProfileMenu4(
              text: "Sedrick Franck DEH TAGOU",
            subtitle: "Cliquer pour accéder au profil LinkedIn",
            imagePath:"assets/images/deh.jpg",
            press: () {
              launchUrl(Uri.parse("https://www.linkedin.com/in/sedrick-frank-deh-tagou/"));
              },
               titleSize: 18,
            ),
            const SizedBox(height: 20),
         ],
        )
      ),
      ),
    );
  }

  Widget itemProfile2(String title, String subtitle, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        children: [
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 itemProfile3(String subtitle) {
    return Container(
      child: ListTile(
        subtitle: Text(subtitle,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15
        )),
        tileColor: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }

  class ProfileMenu4 extends StatelessWidget {
  final String text;
  final String subtitle;
  final String imagePath;
  final double titleSize;
  final VoidCallback? press;

  const ProfileMenu4({Key? key, required this.text, required this.subtitle, required this.imagePath, this.press, required this.titleSize,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(5)
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const  Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width:10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
                  Text(
                    text,
                    style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
                  ),
                ),
                SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
                  Text(
                    "Cliquez pour accéder au profil LinkedIn",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                  ),
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