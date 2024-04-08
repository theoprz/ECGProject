// tag_utils.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../classes/TagNode.dart';
import 'child_tag_selection_page.dart';

List<TagNode> selectTagAndAncestors(TagNode node) {
  List<TagNode> selectedTags = [node];

  if (node.parent != null) {
    selectedTags.addAll(selectTagAndAncestors(node.parent!));
  }


  return selectedTags;
}


Widget buildTagNode(BuildContext context, TagNode node) {
  return ListTile(
    title: Text('${node.tag.name}'),
    subtitle: Text('ID: ${node.tag.id}, Parent ID: ${node.tag.parentId}'),
    trailing: node.children.isNotEmpty ? Icon(Icons.arrow_forward_ios) : null,
    onTap: () {
      if (node.children.isEmpty) {
        List<TagNode> selectedTags = selectTagAndAncestors(node);
        // Print all selected tags
        selectedTags.forEach((tagNode) {
          print("Selected tag: ${tagNode.tag.name}");
        });

        // Retour à l'écran des tags racine
        for(int i = 0; i < selectedTags.length -1; i++){
        Navigator.pop(context);
      }

      } else
      if (node.children.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChildTagSelectionPage(parent: node)),
        );
      }
    },
  );
}
