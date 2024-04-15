import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'Tag.dart';

class ECG {
  String title;
  String description;
  int patientAge;
  String patientSex; // 0 or 1
  int patientSexId = 0;
  List<Tag> tags = [];
  String id;
  String? date;
  String quality = "Non renseignée";
  int qualityId = 0;
  int vitesse = 0;
  int gain = 0;
  File photo;

  ECG(this.title, this.description, this.patientAge, this.patientSex, this.tags, this.id, this.photo);//Constructeur de base

  ECG.withQualitySpeedGain(this.title, this.description, this.patientAge, this.patientSex, this.tags, this.id, this.quality, this.vitesse, this.gain, this.photo);//Constructeur avec les paramètres de qualité, vitesse et gain

  @override
  String toString() {
    return 'ECG{title: $title, description: $description, patientAge: $patientAge, patientSex: $patientSex, tags: $tags, id: $id, quality: $quality, vitesse: $vitesse, gain: $gain}';
  }

  Future<void> setECGFromQuery(i) async {
    var url = Uri.parse('http://173.212.207.124:3333/api/v1/ecg');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> dataList = jsonDecode(response.body)['content'];

        title = dataList[i]['title'];
        description = dataList[i]['comment'];
        patientAge = dataList[i]['age'];
        patientSex = transformSexe(dataList[i]['sexe']);
        patientSexId = dataList[i]['sexe'];
        id = dataList[i]['id'];
        date = "test";
        quality = handleQuality(dataList[i]['quality']);
        qualityId = dataList[i]['quality'];
        if(dataList[i]['filename'] == ""){
          photo = File('assets/images/noimg.jpg');
        } else {
          photo = File(dataList[i]['filename']);
        }

        vitesse = dataList[i]['speed'];
        gain = dataList[i]['gain'];

        tags.clear();
        int tagLength = dataList[i]['tags'].length;
        for (int j = 0; j < tagLength; j++) {
          Tag tag = Tag(dataList[i]['tags'][j]['id'].toString(), dataList[i]['tags'][j]['name'].toString(), dataList[i]['tags'][j]['parentId'].toString());
          tags.add(tag);
        }
      } else {
        print('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception lors de la requête: $e');
    }
  }


  String getStringOfAllTags(){
    String result = "";
    for (Tag tag in tags){
      result += "${tag.name}     |     ";
    }
    return result;
  }
  List<String> getListOfAllTagsNamesAsStrings(){
    List<String> result = [];
    for (Tag tag in tags){
      result.add(tag.name);
    }
    return result;
  }

  void setTags(List<Tag> tags){
    this.tags = tags;
  }

}

String transformSexe(int sexe){
  if (sexe == 0){
    return "Homme";
  } else if (sexe == 1){
    return "Femme";
  } else {
    return "Non renseigné";
  }

}

String epochToFrenchDate(int epochTime) {
  // Convert epoch time to DateTime
  DateTime date = DateTime.fromMillisecondsSinceEpoch(epochTime * 1000);//En dart l'epoch fonctionne en ms et pas en s donc je multiplie par 1000


  List<String> monthNames = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];//On définit le nom des mois

  String monthName = monthNames[date.month - 1];//On récupère le nom du mois

  return '${date.day}\n$monthName\n${date.year}';
}

String handleQuality(int quality) {
  switch (quality) {
    case 1:
      return 'Mauvaise';
    case 2:
      return 'Moyenne';
    case 3:
      return 'Bonne';
    case 4:
      return 'Très bonne';
    default:
      return 'Non renseignée';
  }
}

