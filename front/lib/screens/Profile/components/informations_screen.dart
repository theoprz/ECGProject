import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child:SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            itemProfile2("Quelles informations souhaitez-vous consulter ?",
             "L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible"),
            const SizedBox(height: 20),
            itemProfile2("Quelles informations souhaitez-vous consulter ?",
             "L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible"),
            const SizedBox(height: 20),
            itemProfile2("Quelles informations souhaitez-vous consulter ?", 
            "L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible"),
            const SizedBox(height: 20),
            itemProfile2("Quelles informations souhaitez-vous consulter ?", 
            "L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible"),
            const SizedBox(height: 20),
             itemProfile2("Quelles informations souhaitez-vous consulter ?", 
            "L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible, L'information sera bientot disponible"),
            const SizedBox(height: 20)
         ],
        )
      ),
      ),
    );
  }

  itemProfile2(String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Color.fromARGB(255, 46, 0, 253).withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10
            )
          ]
      ),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        tileColor: Colors.white,
      ),
    );
  }
}