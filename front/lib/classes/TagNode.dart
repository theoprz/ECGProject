import 'Tag.dart';

class TagNode {
  Tag tag;
  List<TagNode> children;
  TagNode? parent;

  TagNode(this.tag, {this.parent}) : children = [];


  //On réécrit la méthodes equals  pour pouvoir comparer des TagNode entre eux
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TagNode &&
        other.tag.id == tag.id &&
        other.tag.name == tag.name &&
        other.tag.parentId == tag.parentId;
  }


}