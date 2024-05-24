import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

//Define Node class
class UserName {
  final String firstName;
  final String lastName;

  UserName(this.firstName, this.lastName);
}

//Dummy Tree
final tree = TreeNode<UserName>.root(data: UserName("User", "Names"))
  ..addAll([
    TreeNode<UserName>(key: "0A", data: UserName("Sr. John", "Doe"))
      ..add(TreeNode(key: "0A1A", data: UserName("Jr. John", "Doe"))),
    TreeNode<UserName>(key: "0C", data: UserName("General", "Lee"))
      ..addAll([
        TreeNode<UserName>(key: "0C1A", data: UserName("Major", "Lee")),
        TreeNode<UserName>(key: "0C1B", data: UserName("Happy", "Lee")),
        TreeNode<UserName>(key: "0C1C", data: UserName("Busy", "Lee"))
          ..addAll([
            TreeNode<UserName>(key: "0C1C2A", data: UserName("Jr. Busy", "Lee"))
          ]),
      ]),
    TreeNode<UserName>(key: "0D", data: UserName("Mr. Anderson", "Neo")),
    TreeNode<UserName>(key: "0E", data: UserName("Mr. Smith", "Agent")),
  ]);

class TreeViewWidget extends StatelessWidget {
    const TreeViewWidget({Key? key}) : super(key: key);
    
    @override
    Widget build(BuildContext context) {
      return TreeView.simpleTyped<UserName, TreeNode<UserName>>(
        tree: tree,
        expansionBehavior: ExpansionBehavior.snapToTop,
        shrinkWrap: true,
        builder: (context, node) => Card(
          child: ListTile(
            title: Text("Item ${node.level}-${node.key}"),
            subtitle: Text('${node.data?.firstName} ${node.data?.lastName}'),
          ),
        ),
      );
    }
}

