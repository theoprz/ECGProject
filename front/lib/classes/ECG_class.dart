import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'Tag.dart';

class ECG {
  String title;
  String description;
  int patientAge;
  String patientSex; // 0 or 1
  List<Tag> tags = [];
  int id;
  String? date;

  ECG(this.title, this.description, this.patientAge, this.patientSex, this.tags, this.id);

  @override
  String toString() {
    return 'ECG{title: $title, description: $description, patientAge: $patientAge, patientSex: $patientSex, tags: $tags, id: $id}';
  }

  void setECGFromQuery(){
    //À dev quand on a le côté back
  }

  Future<void> setECGFromJson() async {
    String jsonString = await rootBundle.loadString('assets/test.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    title = jsonData['page_title'];
    description = jsonData['ecg_comment'];
    patientAge = int.parse(jsonData['ecg_age']);
    patientSex = transformSexe(jsonData['ecg_sexe']);
    id = int.parse(jsonData['ecg_id']);


    String ecgCreated = jsonData['ecg_created'];

    ecgCreated = ecgCreated.replaceAll('\ufffd', '');//On retire les caractères de remplacement qui pourraient être présents
    int epochDate = int.parse(ecgCreated);//On convertit le string en int

    date = DateFormat.yMMMMd().format(DateTime.fromMillisecondsSinceEpoch(epochDate * 1000));//On convertit l'epoch en date

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


  return "";
}

