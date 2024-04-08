import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../classes/TagNode.dart';

class ChildTagSelectionPage extends StatelessWidget {
  final TagNode parent;

  ChildTagSelectionPage({required this.parent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Tags of ${parent.tag.name}'),
      ),
      body: ListView(
        children: parent.children.map((child) => buildTagNode(context, child, 0)).toList(),
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