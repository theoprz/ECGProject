import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../../widgets/constant.dart';
class CompteScreen extends StatelessWidget {
  const CompteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mon compte"),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child:SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),
            CircleAvatar(
              radius: 90,
              backgroundImage: AssetImage('assets/images/img_avatar.png'),
            ),
            const SizedBox(height: 20),
            itemProfile('Nom', 'Nom Prénom', CupertinoIcons.person),
            const SizedBox(height: 10),
            itemProfile('Email', 'nomprénom@institution.com', CupertinoIcons.mail),
            const SizedBox(height: 10),
            itemProfile('Statut', 'Médécin', CupertinoIcons.location),
            const SizedBox(height: 20,),
         ],
        ),
      ),
    )
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 239, 239, 239),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
              BoxShadow(
               offset: Offset(0, 5),
             color: Color.fromARGB(255, 255, 255, 255).withOpacity(.2),
                spreadRadius: 2,
               blurRadius: 10
             )
          ]
      ),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        tileColor: Colors.white,
      ),
    );
  }
}

