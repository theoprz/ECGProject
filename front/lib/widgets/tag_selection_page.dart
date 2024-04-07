import 'package:flutter/material.dart';
import 'TagSelector.dart';
import '../classes/Tag.dart';

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
        title: Text('Tag Test Page'),
      ),
      body: FutureBuilder(
        future: loadTagsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error); // Ajoutez cette ligne pour afficher l'erreur dans la console
            return Center(child: Text('Erreur de chargement des tags'));
          } else {
            return ListView.builder(
              itemCount: tagSelector.tags.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tagSelector.tags[index].name),
                  subtitle: Text('ID: ${tagSelector.tags[index].id}, Parent ID: ${tagSelector.tags[index].parentId}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}