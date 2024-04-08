import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/widgets/tag_utils.dart';

import '../classes/TagNode.dart';

class ChildTagSelectionPage extends StatelessWidget {
  final TagNode parent;

  ChildTagSelectionPage({required this.parent});

  @override
  Widget build(BuildContext context) {
    var sortedChildren = List<TagNode>.from(parent.children);
    sortedChildren.sort((a, b) => a.tag.name.toLowerCase().compareTo(b.tag.name.toLowerCase())); // Tri alphabétique sans distinction entre majuscules et minuscules

    return Scaffold(
      appBar: AppBar(
        title: Text(' ${parent.tag.name}'),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        children: sortedChildren.map((child) => buildTagNode(context, child)).toList(),
      ),
    );
  }



}