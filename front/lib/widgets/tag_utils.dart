// tag_utils.dart
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../classes/Tag.dart';
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

List<TagNode> selectTag(TagNode node) {
  List<TagNode> selectedTags = [node];

  return selectedTags;
}

List<TagNode> generateTagNodesFromTags(List<Tag> tags) {
  var uniqueTagNames = <String>{};
  var uniqueTags = <Tag>[];

  for (var tag in tags) {
    if (!uniqueTagNames.contains(tag.name)) {
      uniqueTagNames.add(tag.name);
      uniqueTags.add(tag);
    }
  }

  var tagNodes = uniqueTags.map((tag) => TagNode(tag)).toList();
  tagNodes.sort((a, b) => a.tag.name.compareTo(b.tag.name));

  return tagNodes;
}


Widget buildTagNode(BuildContext context, TagNode node, [TextEditingController? searchController]) {//Le controller est optionnel, cela permet de vider la barre de recherche lors de la sélection d'un tag
  return Container(
      decoration: BoxDecoration(
      border: Border(
      bottom: BorderSide(width: 1, color: Colors.grey.shade300), // Ajoute une bordure en bas
      ),
    ),
    child:ListTile(
      title: Text(node.tag.name),
      trailing: node.children.isNotEmpty ? const Icon(Icons.arrow_forward_ios) : null,
      onTap: () {
        if (node.children.isEmpty) {
          List<TagNode> selectedTags = selectTag(node);
          int nbParents = selectTagAndAncestors(node).length;

          // Vider le champ de recherche si un contrôleur est fourni
          if (searchController != null) {
            searchController.text = '';
          }

          // Fermer le clavier
          FocusScope.of(context).unfocus();

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
          for(int i = 0; i < nbParents -1; i++){
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

