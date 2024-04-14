import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'Tag.dart';

class ECG {
  String title;
  String description;
  int patientAge;
  String patientSex; // 0 or 1
  List<Tag> tags = [];
  int id;
  String? date;
  String quality = "Non renseignée";
  int vitesse = 0;
  int gain = 0;

  ECG(this.title, this.description, this.patientAge, this.patientSex, this.tags, this.id);//Constructeur de base

  ECG.withQualitySpeedGain(this.title, this.description, this.patientAge, this.patientSex, this.tags, this.id, this.quality, this.vitesse, this.gain);//Constructeur avec les paramètres de qualité, vitesse et gain

  @override
  String toString() {
    return 'ECG{title: $title, description: $description, patientAge: $patientAge, patientSex: $patientSex, tags: $tags, id: $id, quality: $quality, vitesse: $vitesse, gain: $gain}';
  }

  void setECGFromQuery(){
    //À dev quand on a le côté back
  }

  Future<void> setECGFromJson() async {
    String jsonString = await rootBundle.loadString('assets/test.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    title = jsonData['page_title'];
    description = jsonData['ecg_contexte'];
    patientAge = int.parse(jsonData['ecg_age']);
    patientSex = transformSexe(jsonData['ecg_sexe']);
    id = int.parse(jsonData['ecg_id']);

    quality = handleQuality(int.parse(jsonData['ecg_quality'])); //On transforme le int de la qualité en string
    vitesse = int.parse(jsonData['ecg_speed']);
    gain = int.parse(jsonData['ecg_gain']);



    String ecgCreated = jsonData['ecg_created'];

    ecgCreated = ecgCreated.replaceAll('\ufffd', '');//On retire les caractères de remplacement qui pourraient être présents
    int epochDate = int.parse(ecgCreated);//On convertit le string en int

    date = epochToFrenchDate(epochDate);//On convertit l'epoch en date lisible

    tags.clear();
    for (var tagData in jsonData['tags']) {
      Tag tag = Tag(tagData['etag_id'], tagData['etag_name'],  tagData['etag_parent_id']);
      tags.add(tag);
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

String transformSexe(String sexe){
  if (sexe == "0"){
    return "Homme";
  } else if (sexe == "1"){
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

