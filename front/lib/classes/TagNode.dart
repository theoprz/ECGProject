import 'Tag.dart';

class TagNode {
  Tag tag;
  List<TagNode> children;
  TagNode? parent;

  TagNode(this.tag, {this.parent}) : children = [];
}