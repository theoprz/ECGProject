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

  ECG(this.title, this.description, this.patientAge, this.patientSex, this.tags, this.id);

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

    tags.clear();
    for (var tagData in jsonData['tags']) {
      Tag tag = Tag(tagData['etag_id'], tagData['etag_name'], tagData['etag_type'], tagData['etag_parent_id']);
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

