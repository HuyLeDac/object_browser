import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

// Node for each object
class CNCObjectNode {
  final int group;
  final int offset;
  final String name;
  final String dataType;
  final int length;
  final String unit;
  final int cValue;
  final String? value;  // Assuming value is a string representation, modify as needed.

  CNCObjectNode(this.group, this.offset, this.name, this.dataType, this.length, this.unit, this.cValue, this.value);
}

// Dummy Tree, only for illustration 
final tree = TreeNode<CNCObjectNode>.root(data: CNCObjectNode(0, 0, "Root", "ROOT_TYPE", 0, "-", 0, null))
  ..addAll([
    TreeNode<CNCObjectNode>(key: "0A", data: CNCObjectNode(1180416, 0, "POS-CTRL: elements", "UNS32", 4, "-", 1, "&value_list[0]"))
      ..add(TreeNode(key: "0A1A", data: CNCObjectNode(1180416, 1, "cycle time", "REAL64", 8, "s", 1, "&value_list[1]"))),
    TreeNode<CNCObjectNode>(key: "0C", data: CNCObjectNode(1180416, 2, "number of axes", "UNS16", 2, "-", 1, "&value_list[2]"))
      ..addAll([
        TreeNode<CNCObjectNode>(key: "0C1A", data: CNCObjectNode(1180416, 3, "logical axis ID by index", "NN", 2, "-", 0, null)),
        TreeNode<CNCObjectNode>(key: "0C1B", data: CNCObjectNode(1180416, 4, "log errors", "_BOOL", 1, "-", 1, "&value_list[3]")),
        TreeNode<CNCObjectNode>(key: "0C1C", data: CNCObjectNode(1180416, 5, "retain.data_valid", "_BOOL", 1, "-", 1, "&value_list[4]"))
          ..addAll([
            TreeNode<CNCObjectNode>(key: "0C1C2A", data: CNCObjectNode(1180416, 6, "axis state: compatibility mode", "_BOOL", 1, "-", 1, "&value_list[5]"))
          ]),
      ]),
    TreeNode<CNCObjectNode>(key: "0D", data: CNCObjectNode(1180416, 7, "tick counter", "UNS32", 4, "-", 1, "&value_list[6]")),
    TreeNode<CNCObjectNode>(key: "0E", data: CNCObjectNode(1180416, 8, "cyclic_call", "_BOOL", 1, "-", 1, "&value_list[7]")),
  ]);


// Build tree 
class TreeViewWidget extends StatelessWidget {
  final double fontSize;

  const TreeViewWidget({Key? key, required this.fontSize}) : super(key: key);
    
  @override
  Widget build(BuildContext context) {
    return TreeView.simpleTyped<CNCObjectNode, TreeNode<CNCObjectNode>>(
      tree: tree,
      expansionBehavior: ExpansionBehavior.snapToTop,
      shrinkWrap: true,
      builder: (context, node) => Card(
        child: ListTile(
          title: Text("Item ${node.level}-${node.key}", style: TextStyle(fontSize: fontSize)),
          subtitle: Text('Group: ${node.data?.group}\nName: ${node.data?.name}', style: TextStyle(fontSize: fontSize)),
        ),
      ),
    );
  }
}
