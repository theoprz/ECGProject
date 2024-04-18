import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:uuid/uuid.dart';

import 'package:front/widgets/tag_utils.dart';
import '../classes/ECG_class.dart';
import '../classes/Tag.dart';
import '../classes/TagNode.dart';
import 'TagSelector.dart';


class TagSelectionPage extends StatefulWidget {
  final ECG ecg;

  const TagSelectionPage({super.key, required this.ecg});

  @override
  _TagSelectionPageState createState() => _TagSelectionPageState();
}

class _TagSelectionPageState extends State<TagSelectionPage> {
  TagSelector tagSelector = TagSelector();
  Future<void>? loadTagsFuture;
  final TextEditingController _searchcontroller = TextEditingController();
  List<Tag> filteredTags = [];

  @override
  void initState() {
    super.initState();
    loadTagsFuture = tagSelector.loadTags();
    _searchcontroller.addListener(searchListener);
  }

  void searchListener() {
    String searchText = _searchcontroller.text;
    if (searchText.isEmpty) {
      setState(() {
        filteredTags = tagSelector.tags;
      });
    } else {
      setState(() {
        filteredTags = tagSelector.tags.where((tag) {
          return tag.name.toLowerCase().contains(searchText.toLowerCase());
        }).toList();
      });
    }
  }

  Future<void> uploadPhoto(File imageFile, String ecgId) async {
    var uri = Uri.parse('http://173.212.207.124:3333/api/v1/ecg/upload/file');
    var request = http.MultipartRequest('POST', uri);

    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var multipartFile = http.MultipartFile(
      'image',
      stream,
      length,
      filename: basename(imageFile.path),
    );

    request.files.add(multipartFile);
    request.fields['ecgId'] = ecgId;
    print("ecgId: $ecgId");

    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      print('Photo uploaded successfully');
      print('Response: ${response.body}');
    } else {
      print('Failed to upload photo. Status code: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _searchcontroller.removeListener(searchListener);
    _searchcontroller.dispose();
    super.dispose();
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Sélection de tags'),
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
    ),
    body: FutureBuilder(//Liste des tags
      future: loadTagsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erreur de chargement des tags'));
        } else {
          List<TagNode> roots = tagSelector.buildTagTree(filteredTags.isEmpty ? tagSelector.tags : filteredTags);
          roots.sort((a, b) => a.tag.name.toLowerCase().compareTo(b.tag.name.toLowerCase())); //Tri alphabétique des racines
          return Column(//Sous l'appbar
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 10, bottom: 10),
                  child: TextField(
                    controller: _searchcontroller,
                    decoration: InputDecoration(
                      labelText: 'Rechercher un tag',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchcontroller.clear();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),

              StreamBuilder<List<TagNode>>(
                stream: globalSelectedTagsController.stream,
                builder: (context, snapshot) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 110), //Hauteur maximale de la liste
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
                                    tagNode.tag.name,
                                    style: const TextStyle(fontSize: 14),
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
                    children: _searchcontroller.text.isEmpty ? roots.map((root) => buildTagNode(context, root, _searchcontroller)).toList() : generateTagNodesFromTags(filteredTags).map((node) => buildTagNode(context, node, _searchcontroller)).toList(),
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
        var uuid = const Uuid();
        widget.ecg.id = uuid.v4();
        widget.ecg.date = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();


        // Création de l'objet Ecg à envoyer

        int handleQuality(String quality) {
          switch (quality) {
            case "Mauvaise":
              return 1;
            case "Moyenne":
              return 2;
            case "Bonne":
              return 3;
            case "Très bonne":
              return 4;
            default:
              return 0;
          }
        }

        int transformSexe(String sexe){
          if (sexe == "Masculin"){
            return 0;
          } else if (sexe == "Féminin"){
            return 1;
          } else {
            return 3;
          }

        }

        List<int> transformSymptoms(List<dynamic> symptoms){
          List<int> result = [];
          for (String symptom in symptoms){
            switch (symptom){
              case "Douleur thoracique":
                result.add(1);
                break;
              case "Dyspnée":
                result.add(2);
                break;
              case "Palpitations":
                result.add(3);
                break;
              case "Syncope":
                result.add(4);
                break;
            }
          }
          return result;
        }


        Map<String, dynamic> ecgData = {
          "id": widget.ecg.id,
          "title": widget.ecg.title,
          "contexte": widget.ecg.description,
          "comment": "No comment yet.",
          "age": widget.ecg.patientAge,
          "sexe": transformSexe(widget.ecg.patientSex),
          "filename": "${widget.ecg.id}.jpg",
          "posted_by": "1",
          "validated_by": "1",
          "created": widget.ecg.date,
          "validated": "0",
          "pixels_cm": "0",
          "speed": widget.ecg.vitesse,
          "gain": widget.ecg.gain,
          "quality": handleQuality(widget.ecg.quality),
          "tags": tagList.map((tag) => tag.id).toList(), // Supposant que l'id de chaque tag est requis
          "symptoms": transformSymptoms(widget.ecg.listeSymptomes),
        };

        Uri url = Uri.parse('http://173.212.207.124:3333/api/v1/ecg');

        print(ecgData);
        try {
          var response = await http.post(
            url,
            body: json.encode(ecgData),
            headers: {'Content-Type': 'application/json'},
          );

          // Vérification de la réponse de l'API
          if (response.statusCode == 201) {
            print('Ecg envoyé avec succès');
            print('Réponse: ${response.body}');
            // Naviguer vers l'écran d'accueil et vider la liste des tags
            globalSelectedTags.clear();
            globalSelectedTagsController.add(globalSelectedTags);

            Navigator.popUntil(context, ModalRoute.withName('/'));
          } else {
            print('Erreur lors de l\'envoi de l\'Ecg : ${response.statusCode} ${response.body}');
            // Gérer l'erreur en conséquence
          }
        } catch (error) {
          print('Erreur lors de la requête : $error');
          // Gérer l'erreur en conséquence
        }

        // Envoi de la photo
        if (widget.ecg.photo.path != 'assets/images/noimg.jpg') {
          print(widget.ecg.id);
          await uploadPhoto(widget.ecg.photo, widget.ecg.id);
        }

      },
      label: Row(
        children: [
          const Text('Confirmer les'),
          const SizedBox(width: 5), //Espace entre texte et cercle
          StreamBuilder<List<TagNode>>(
            stream: globalSelectedTagsController.stream,
            builder: (context, snapshot) {
              return Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, //Couleur du cercle
                ),
                child: Text('${globalSelectedTags.length}'),
              );
            },
          ),
          const SizedBox(width: 5), //Espace entre texte et cercle
          const Text('tags'),
        ],
      ),
    ),
  );
}

}
