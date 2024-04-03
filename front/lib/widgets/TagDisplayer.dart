import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../classes/Tag.dart';


class TagDisplayer extends StatefulWidget {
  final Tag tag;

  const TagDisplayer({Key? key, required this.tag}) : super(key: key);

  @override
  _TagDisplayerState createState() => _TagDisplayerState();
}

class _TagDisplayerState extends State<TagDisplayer> {
  // Controller for scrolling ListView
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95, // Set the width to the value you want
        child: Container(
          padding: const EdgeInsets.all(20),//Padding autour des éléments du tags
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("${widget.tag.name}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text("id :${widget.tag.id}"),
              const SizedBox(height: 5),
              Text("parentId :${widget.tag.parentId}"),
              const SizedBox(height: 5),
              Text("type :${widget.tag.type}"),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

