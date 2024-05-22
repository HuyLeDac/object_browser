import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:object_browser/loading_dialogue.dart';
//import 'dart:ffi' as ffi;
//import 'dart:io' show Platform, Directory;
//import 'package:path/path.dart' as path;


void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

//Tree Node class for building a Tree
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


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('ObjectBrowser'),
      ),

      body: Column(
        children: <Widget>[ 
          Row(
            // Load button, add other buttons later 
            children: <Widget>[
              const SizedBox(width: 20), // Adds horizontal space of 20 pixels

              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const LoadingDialog(); // Show loading dialog when button is pressed
                    },
                  );
                },
                child: const Text('Load CNC objects'),
              ),

              const SizedBox(width: 20), // Adds horizontal space of 20 pixels

              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const LoadingDialog(); // Dummy for modifying DLL paths
                    },
                  );
                },
                child: const Text('Modify DLL path'),
              ),

              const SizedBox(width: 20), // Adds horizontal space of 20 pixels

              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const LoadingDialog(); // Dummy for other buttons 
                    },
                  );
                },
                child: const Text('...'),
              ),
            ]

          ),
          
          // Two columns, one for tree and one for table which should illustrate all objects
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              const SizedBox(width: 20), // Adds horizontal space of 20 pixels

              //const Card(
              //  child: Text('Tree'), //Tree dummy, implement Tree with flutter_fancy_tree_view,
              //),
              Expanded(
                child:TreeView.simpleTyped<UserName, TreeNode<UserName>>(
                  tree: tree,
                  expansionBehavior: ExpansionBehavior.collapseOthersAndSnapToTop,
                  shrinkWrap: true,
                  builder: (context, node) => Card(
                    child: ListTile(
                      title: Text("Item ${node.level}-${node.key}"),
                      subtitle: Text('${node.data?.firstName} ${node.data?.lastName}'),
                    ),
                  ),
                ),
              ),


              const SizedBox(width: 20), // Adds horizontal space of 20 pixels

              Card(
                child: Column( // Table dummy, use DataTable
                  children: <Widget>[
                    const Text('Table'), 
                    DataTable(  
                      columns: const [
                        DataColumn(
                          label: Text('Nr:'),
                        ),
                        DataColumn(
                          label: Text('Gruppe'),
                        ),
                        DataColumn(
                          label: Text('Offset:'),
                        ),
                        DataColumn(
                          label: Text('Bezeichner:'),
                        ),
                        DataColumn(
                          label: Text('Datentyp:'),
                        ),
                        DataColumn(
                          label: Text('Länge:'),
                        ),
                        DataColumn(
                          label: Text('Einheit:'),
                        ),
                        DataColumn(
                          label: Text('Wert:'),
                        ),
                      ], 
                      rows: const [        
                        DataRow(cells: [
                          DataCell(Text('1180416')),
                          DataCell(Text('cycle time')),
                          DataCell(Text('5644645')),
                          DataCell(Text('1180416')),
                          DataCell(Text('cycle time')),
                          DataCell(Text('5644645')),
                          DataCell(Text('1180416')),
                          DataCell(Text('cycle time')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('1180416')),
                          DataCell(Text('cycle time')),
                          DataCell(Text('5644645')),
                          DataCell(Text('1180416')),
                          DataCell(Text('cycle time')),
                          DataCell(Text('5644645')),
                          DataCell(Text('1180416')),
                          DataCell(Text('cycle time')),
                        ])
                      ],
                    ),
                  ]
                ),
              ),

              const SizedBox(width: 20), // Adds horizontal space of 20 pixels

            ],
          )
        ]
      ),
    );
  }
}