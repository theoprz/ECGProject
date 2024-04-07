import 'dart:convert';
import 'package:flutter/services.dart';
import '../classes/Tag.dart';

class TagSelector {
  List<Tag> tags = [];


  Future<void> loadTags() async {
    String jsonString = await rootBundle.loadString('assets/tags.json');
    List<dynamic> jsonData = jsonDecode(jsonString);

    tags.clear();
    for (var tagData in jsonData) {
      String id = tagData['id'] == null || tagData['id'].isEmpty ? "EMPTY" : tagData['id'];
      String name = tagData['name'] == null || tagData['name'].isEmpty ? "EMPTY" : tagData['name'];
      String parentId = tagData['parent_id'] == null || tagData['parent_id'].isEmpty ? "EMPTY" : tagData['parent_id'];

      Tag tag = Tag(id, name, parentId);
      tags.add(tag);
    }
    print("Tags loaded");
  }
}