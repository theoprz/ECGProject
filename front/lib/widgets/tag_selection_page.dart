import 'package:flutter/material.dart';
import 'package:front/widgets/tag_utils.dart';
import '../classes/ECG_class.dart';
import '../classes/Tag.dart';
import '../classes/TagNode.dart';
import 'TagSelector.dart';


class TagSelectionPage extends StatefulWidget {
  ECG ecg;

  TagSelectionPage({required this.ecg});

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
    print(widget.ecg);
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
                    constraints: BoxConstraints(maxHeight: 180), //Hauteur maximale de la liste
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 8),
                        child: Wrap(
                          spacing: 8, //space between the tags
                          runSpacing: 4, //space between the lines
                          children: snapshot.data?.map((tagNode) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  globalSelectedTags.remove(tagNode);
                                  globalSelectedTagsController.add(globalSelectedTags);
                                });
                              },
                              child: Container(
                                width: 180,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.blue.shade200, width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    '${tagNode.tag.name}',
                                    style: TextStyle(fontSize: 14),
                                  ),
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
    floatingActionButton: FloatingActionButton.extended(
      backgroundColor: Colors.blue.shade300,
      onPressed: () {
        //Fonction pour confirmer les tags sélectionnés
        List<Tag> tagList = globalSelectedTags.map((tagNode) => tagNode.tag).toList();
        widget.ecg.setTags(tagList);
        print(widget.ecg);
        print(widget.ecg.getStringOfAllTags());


        globalSelectedTags.clear();
        globalSelectedTagsController.add(globalSelectedTags);

        //TODO ADD THIS ECG TO THE LIST OF ECGS AND GO BACK TO HOMESCREEN
        //TODO FAIRE UN ROUTAGE
        Navigator.popUntil(context, ModalRoute.withName('/'));

      },
      label: Row(
        children: [
          Text('Confirmer les'),
          SizedBox(width: 5), //Espace entre texte et cercle
          StreamBuilder<List<TagNode>>(
            stream: globalSelectedTagsController.stream,
            builder: (context, snapshot) {
              return Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, //Couleur du cercle
                ),
                child: Text('${globalSelectedTags.length}'),
              );
            },
          ),
          SizedBox(width: 5), //Espace entre texte et cercle
          Text('tags'),
        ],
      ),
    ),
  );
}

}


//TODO VALIDATING SELECTION ADD ALL TAGS SELECTED TO THE ECG OBJECT, GOES FORWARD IN SCREENS AND THEN EMPTY TAG LIST