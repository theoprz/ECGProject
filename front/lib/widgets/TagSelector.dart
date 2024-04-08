import 'dart:convert';
import 'package:flutter/services.dart';
import '../classes/Tag.dart';
import '../classes/TagNode.dart';

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

  List<TagNode> roots = buildTagTree(tags);

  print("Tags loaded");
}

List<TagNode> buildTagTree(List<Tag> tags) {
  Map<String, TagNode> tagNodeMap = {};

  for (var tag in tags) {
    tagNodeMap[tag.id] = TagNode(tag);
  }

  List<TagNode> roots = [];

  for (var tagNode in tagNodeMap.values) {
    if (tagNode.tag.parentId == "EMPTY") {
      roots.add(tagNode);
    } else if (tagNodeMap.containsKey(tagNode.tag.parentId)) {
      TagNode parentNode = tagNodeMap[tagNode.tag.parentId]!;
      parentNode.children.add(tagNode);
      tagNode.parent = parentNode; //On garde le lien vers le parent pour pouvoir remonter dans l'arbre
    }
  }

  return roots;
}
}