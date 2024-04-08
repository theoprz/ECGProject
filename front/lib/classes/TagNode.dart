import 'Tag.dart';

class TagNode {
  Tag tag;
  List<TagNode> children;

  TagNode(this.tag) : children = [];
}