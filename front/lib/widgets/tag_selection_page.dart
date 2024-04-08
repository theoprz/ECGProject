import 'package:flutter/material.dart';
import 'package:front/widgets/tag_utils.dart';
import '../classes/TagNode.dart';
import 'TagSelector.dart';
import 'child_tag_selection_page.dart';

class TagSelectionPage extends StatefulWidget {
  @override
  _TagSelectionPageState createState() => _TagSelectionPageState();
}

class _TagSelectionPageState extends State<TagSelectionPage> {
  TagSelector tagSelector = TagSelector();
  Future<void>? loadTagsFuture;
  List<TagNode> selectedTags = [];

  @override
  void initState() {
    super.initState();
    loadTagsFuture = tagSelector.loadTags();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Sélection de tags'),
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
    ),
    body: FutureBuilder(//Liste des tags
      future: loadTagsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error); //Affichage de l'erreur dans la console (À supprimer)
          return Center(child: Text('Erreur de chargement des tags'));
        } else {
          List<TagNode> roots = tagSelector.buildTagTree(tagSelector.tags);
          roots.sort((a, b) => a.tag.name.toLowerCase().compareTo(b.tag.name.toLowerCase())); //Tri alphabétique des racines
          return Column(//Sous l'appbar
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                height: 50,
                width: MediaQuery.of(context).size.width * 0.80,
                child: Column(
                  children: selectedTags.map((tagNode) => Text('Selected tag: ${tagNode.tag.name}')).toList(),
                )
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade600,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: roots.map((root) => buildTagNode(context, root)).toList(),
                ),
              ),
            ],
          );
        }
      },
    ),
  );
}

}


//TODO DISPLAY SELECTED TAGS IN A LIST ABOVE THE TAGS LIST