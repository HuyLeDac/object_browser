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

              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const LoadingDialog(); // Show loading dialog when button is pressed
                    },
                  );
                },
                child: const Text('Modify DLL paths'),
              ),

              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const LoadingDialog(); // Show loading dialog when button is pressed
                    },
                  );
                },
                child: const Text('...'),
              ),
            ]

          ),
          
          // Two columns, one for tree and one for table which should illustrate all objects
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Card(
                child: Text('Tree'), //Tree dummy, implement Tree with flutter_fancy_tree_view,
              ),

              const VerticalDivider(
                color: Colors.black,  //color of divider
                width: 10, //width space of divider
                thickness: 3, //thickness of divier line
                indent: 10, //Spacing at the top of divider.
                endIndent: 10, //Spacing at the bottom of divider. 
              ),

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

              
            ],
          )
        ]
      ),
    );
  }
}