import 'package:flutter/material.dart';
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
          List<TagNode> roots = tagSelector.buildTagTree(tagSelector.tags);
          return ListView(
            children: roots.map((root) => buildTagNode(context, root, 0)).toList(),
          );
        }
      },
    ),
  );
}

  Widget buildTagNode(BuildContext context, TagNode node, int depth) {
  return ListTile(
    title: Text('${'-' * depth} ${node.tag.name}'),
    subtitle: Text('ID: ${node.tag.id}, Parent ID: ${node.tag.parentId}'),
    trailing: node.children.isNotEmpty ? Icon(Icons.arrow_forward_ios) : null,
    onTap: () {
      if (node.children.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChildTagSelectionPage(parent: node)),
        );
      }
    },
  );
}
}