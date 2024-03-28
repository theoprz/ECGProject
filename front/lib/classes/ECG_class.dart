import 'dart:convert';
import 'dart:io';

import 'Tag.dart';

class ECG {
  String title;
  String description;
  int patientAge;
  int patientSex; // 0 or 1
  List<Tag> tags = [];

  ECG(this.title, this.description, this.patientAge, this.patientSex, this.tags);

  void setECGFromQuery(){
    //À dev quand on a le côté back
  }

  void setECGFromJson(String filePath) async {
    final file = File(filePath);
    String jsonString = await file.readAsString();


    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    title = jsonData['page_title'];
    description = jsonData['ecg_comment'];
    patientAge = int.parse(jsonData['ecg_age']);
    patientSex = jsonData['ecg_sexe'];

    tags.clear();
    for (var tagData in jsonData['tags']) {
      Tag tag = Tag(tagData['etag_id'], tagData['etag_name'], tagData['etag_type'], tagData['etag_parent_id']);
      tags.add(tag);
    }
  }
}