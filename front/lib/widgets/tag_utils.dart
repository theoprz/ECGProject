// tag_utils.dart
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../classes/TagNode.dart';
import 'child_tag_selection_page.dart';


StreamController<List<TagNode>> globalSelectedTagsController = StreamController<List<TagNode>>.broadcast();
List<TagNode> globalSelectedTags = [];

List<TagNode> selectTagAndAncestors(TagNode node) {
  List<TagNode> selectedTags = [node];

  if (node.parent != null) {
    selectedTags.addAll(selectTagAndAncestors(node.parent!));
  }


  return selectedTags;
}


Widget buildTagNode(BuildContext context, TagNode node) {
  return Container(
      decoration: BoxDecoration(
      border: Border(
      bottom: BorderSide(width: 1, color: Colors.grey.shade300), // Ajoute une bordure en bas
      ),
    ),
    child:ListTile(
      title: Text('${node.tag.name}'),
      trailing: node.children.isNotEmpty ? Icon(Icons.arrow_forward_ios) : null,
      onTap: () {
        if (node.children.isEmpty) {
          List<TagNode> selectedTags = selectTagAndAncestors(node);

          //Add selected tags to globalSelectedTags if they are not already in the list
          for (TagNode tag in selectedTags) {
            if (!globalSelectedTags.contains(tag)) {
              globalSelectedTags.add(tag);
            }
          }

          //2nd step verification to avoid duplicates
          globalSelectedTags = globalSelectedTags.toSet().toList();

          globalSelectedTagsController.add(globalSelectedTags);

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
    )
  );
}

