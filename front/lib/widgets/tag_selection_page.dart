import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:front/widgets/tag_utils.dart';
import '../classes/ECG_class.dart';
import '../classes/Tag.dart';
import '../classes/TagNode.dart';
import 'TagSelector.dart';


class TagSelectionPage extends StatefulWidget {
  ECG ecg;

  TagSelectionPage({required this.ecg});

  @override
  _TagSelectionPageState createState() => _TagSelectionPageState();
}

class _TagSelectionPageState extends State<TagSelectionPage> {
  TagSelector tagSelector = TagSelector();
  Future<void>? loadTagsFuture;

  @override
  void initState() {
    super.initState();
    loadTagsFuture = tagSelector.loadTags();
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Sélection de tags'),
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
    ),
    body: FutureBuilder(//Liste des tags
      future: loadTagsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur de chargement des tags'));
        } else {
          List<TagNode> roots = tagSelector.buildTagTree(tagSelector.tags);
          roots.sort((a, b) => a.tag.name.toLowerCase().compareTo(b.tag.name.toLowerCase())); //Tri alphabétique des racines
          return Column(//Sous l'appbar
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<List<TagNode>>(
                stream: globalSelectedTagsController.stream,
                builder: (context, snapshot) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 180), //Hauteur maximale de la liste
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 8),
                        child: Wrap(
                          spacing: 8, //space between the tags
                          runSpacing: 4, //space between the lines
                          children: snapshot.data?.map((tagNode) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  globalSelectedTags.remove(tagNode);
                                  globalSelectedTagsController.add(globalSelectedTags);
                                });
                              },
                              child: Container(
                                width: 180,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.blue.shade200, width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    '${tagNode.tag.name}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            );
                          }).toList() ?? [],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade600,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: roots.map((root) => buildTagNode(context, root)).toList(),
                ),
              ),
            ],
          );
        }
      },
    ),
    floatingActionButton: FloatingActionButton.extended(
      backgroundColor: Colors.blue.shade300,
      onPressed: () async {
        // Fonction pour confirmer les tags sélectionnés
        List<Tag> tagList = globalSelectedTags.map((tagNode) => tagNode.tag).toList();
        widget.ecg.setTags(tagList);

        globalSelectedTags.clear();
        globalSelectedTagsController.add(globalSelectedTags);

        // Création de l'objet Ecg à envoyer

        Map<String, dynamic> ecgData = {
          "title": widget.ecg.title,
          "contexte": widget.ecg.description,
          "comment": "No comment yet.",
          "age": widget.ecg.patientAge,
          "sexe": widget.ecg.patientSexId,
          "filename": "test",
          "postedBy": "1",
          "validatedBy": "1",
          "created": "e28ec3a5-25b3-4d82-a5cc-dfc0cd91cd33",
          "validated": "e28ec3a5-25b3-4d82-a5cc-dfc0cd91cd33",
          "pixelsCm": "0",
          "speed": widget.ecg.vitesse,
          "gain": widget.ecg.gain,
          "quality": widget.ecg.qualityId,
          "tags": tagList.map((tag) => tag.id).toList(), // Supposant que l'id de chaque tag est requis
        };

        Uri url = Uri.parse('http://173.212.207.124:3333/api/v1/ecg');

        try {
          var response = await http.post(
            url,
            body: json.encode(ecgData),
            headers: {'Content-Type': 'application/json'},
          );

          // Vérification de la réponse de l'API
          if (response.statusCode == 201) {
            print('Ecg envoyé avec succès');
            // Naviguer vers l'écran d'accueil ou effectuer toute autre action nécessaire
            Navigator.popUntil(context, ModalRoute.withName('/'));
          } else {
            print('Erreur lors de l\'envoi de l\'Ecg : ${response.statusCode}');
            // Gérer l'erreur en conséquence
          }
        } catch (error) {
          print('Erreur lors de la requête : $error');
          // Gérer l'erreur en conséquence
        }
/*
          // Créer une requête multipart
          var request = http.MultipartRequest('POST', Uri.parse('http://173.212.207.124:3333/api/v1/ecg/upload/file'));

          // Ajouter le fichier à la requête
          var fileStream = http.ByteStream(widget.ecg.photo.openRead());
          var length = await widget.ecg.photo.length();
          var multipartFile = http.MultipartFile('file', fileStream, length,
              filename: widget.ecg.photo.path.split('/').last); // Déterminez le nom du fichier à partir du chemin

          request.files.add(multipartFile);

          // Envoyer la requête
          var response = await request.send();

          // Lire la réponse
          if (response.statusCode == 200) {
            print('File uploaded successfully');
          } else {
            print('Error uploading file: ${response.statusCode}');
          }
          */
      },
      label: Row(
        children: [
          Text('Confirmer les'),
          SizedBox(width: 5), //Espace entre texte et cercle
          StreamBuilder<List<TagNode>>(
            stream: globalSelectedTagsController.stream,
            builder: (context, snapshot) {
              return Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, //Couleur du cercle
                ),
                child: Text('${globalSelectedTags.length}'),
              );
            },
          ),
          SizedBox(width: 5), //Espace entre texte et cercle
          Text('tags'),
        ],
      ),
    ),
  );
}

}


//TODO VALIDATING SELECTION ADD ALL TAGS SELECTED TO THE ECG OBJECT, GOES FORWARD IN SCREENS AND THEN EMPTY TAG LIST