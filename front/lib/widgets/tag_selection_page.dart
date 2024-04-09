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
              StreamBuilder<List<TagNode>>(
                stream: globalSelectedTagsController.stream,
                builder: (context, snapshot) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 180), // Définissez la hauteur maximale que vous voulez ici
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 8),
                        child: Wrap(
                          spacing: 8, // space between the tags
                          runSpacing: 4, // space between the lines
                          children: snapshot.data?.map((tagNode) {
                            return Container(
                              width: 180,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.red.shade700, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  '${tagNode.tag.name}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            );
                          }).toList() ?? [],
                        ),
                      ),
                    ),
                  );
                },
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
//TODO EMPTY LIST WHEN USER QUITS TAG SELECTION
//TODO ADD A DELETE BUTTON ON TAGS IN THE LIST
//TODO ADD A CLEAR BUTTON TO EMPTY THE LIST
//TODO ADD A VALIDATE BUTTON TO VALIDATE THE SELECTION
//TODO RETIRER LES DOUBLONS DANS LA LISTE DES TAGS SÉLECTIONNÉS