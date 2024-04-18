import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CompteScreen extends StatelessWidget {
  final Credentials credentials;

  const CompteScreen({Key? key, required this.credentials}) : super(key: key);

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
              backgroundImage: credentials.user.pictureUrl != null
                  ? NetworkImage(credentials.user.pictureUrl.toString()) as ImageProvider<Object>?
                  : AssetImage('assets/images/img_avatar.png'),
            ),
            const SizedBox(height: 20),
            itemProfile('Nom', credentials.user.sub.toString(), CupertinoIcons.person),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            itemProfile('Email', credentials.user.email.toString(), CupertinoIcons.mail),
            const SizedBox(height: 20),
            itemProfile('Statut', "Inconnu", CupertinoIcons.location),
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

