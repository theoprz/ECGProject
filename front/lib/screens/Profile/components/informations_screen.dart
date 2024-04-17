import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:front/widgets/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A propos de nous"),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child:SingleChildScrollView(
        child: Column(
          children: [
            itemProfile3("Nous sommes des étudiants de Junia ISEN. Nous avons réalisé ce projet avec beaucoup de passion et de nuits blanches"),
            const SizedBox(height: 20),
            ProfileMenu4(
             text: "THEO PORZIO",
             subtitle: "Cliquer pour acceder au profil linkdin",
             imagePath: "assets/images/Theo.jpeg",
             press: () {
               launchUrl(Uri.parse("https://www.linkedin.com/in/th%C3%A9o-porzio-6537b11a4/"));
              },
             ),
             
            const SizedBox(height: 20),
            
            ProfileMenu4(
              text: "AURELIEN ROGE",
             subtitle: "Cliquer pour acceder au profil linkdin",
             imagePath: "assets/images/Aurelien.jpeg",
             press: () {
               launchUrl(Uri.parse("https://www.linkedin.com/in/aurelien-roge-0b5b9b1b6/"));
              },
             ),
            const SizedBox(height: 20),
            ProfileMenu4(
              text: "ALEXANDRE DEPREZ", 
            subtitle: "Cliquer pour acceder au profil linkdin",
            imagePath:"assets/images/ALEXANDRE.jpeg",
             press: () {
               launchUrl(Uri.parse("https://www.linkedin.com/in/alexandre-deprez/"));
              },
            ),
            const SizedBox(height: 20),
            ProfileMenu4(
              text: "AHOLOU MELCHIOR", 
            subtitle: "Cliquer pour acceder au profil linkdin",
            imagePath:"assets/images/Melchior.JPG",
            press: () {
              launchUrl(Uri.parse("https://www.linkedin.com/in/melchior-aholou/"));
              },),
            const SizedBox(height: 20),
             ProfileMenu4(
              text: "SEDRICK FRANCK DEH TAGOU", 
            subtitle: "Cliquer pour acceder au profil linkdin",
            imagePath:"assets/images/deh.jpg",
            press: () {
              launchUrl(Uri.parse("https://www.linkedin.com/in/sedrick-frank-deh-tagou/"));
              },
            ),
            const SizedBox(height: 20),
             ProfileMenu4(
              text: "PAUL MAERTEN", 
            subtitle: "Cliquer pour acceder au profil linkdin",
            imagePath:"assets/images/noimg.jpg",
            press: () {
            launchUrl(Uri.parse('https://github.com/theoprz/ECGProject'));
              },
            ),
            const SizedBox(height: 20)
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
  final VoidCallback? press;

  const ProfileMenu4({
    Key? key,
    required this.text,
    required this.subtitle,
    required this.imagePath,
    this.press,
  }) : super(key: key);

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
          padding: const EdgeInsets.all(30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const  Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 30),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: 
                Text(
                  text,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                ),
                SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: 
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 164, 164, 164)),
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