import 'package:flutter/material.dart';
import 'package:front/widgets/tag_utils.dart';

import '../classes/TagNode.dart';

class ChildTagSelectionPage extends StatelessWidget {
  final TagNode parent;

  const ChildTagSelectionPage({super.key, required this.parent});

  @override
  Widget build(BuildContext context) {
    var sortedChildren = List<TagNode>.from(parent.children);
    sortedChildren.sort((a, b) => a.tag.name.toLowerCase().compareTo(b.tag.name.toLowerCase())); // Tri alphabétique sans distinction entre majuscules et minuscules

    return Scaffold(
      appBar: AppBar(
        title: Text(' ${parent.tag.name}'),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0), // Ajoutez une marge à droite de l'icône
            child: IconButton(
              icon: const Icon(Icons.check),
              iconSize: 30,
              onPressed: () {
                //FUNCTION TO ADD FROM THIS TAG WITHOUT CHILDREN
                List<TagNode> selectedTags = selectTagAndAncestors(parent);

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
                for(int i = 0; i < selectedTags.length ; i++){
                  Navigator.pop(context);
                }

              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: sortedChildren.map((child) => buildTagNode(context, child)).toList(),
      ),
    );
  }



}