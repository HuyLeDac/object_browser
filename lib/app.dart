import 'package:flutter/material.dart';
import 'package:object_browser/loading_dialogue.dart';
import 'package:object_browser/tree_node.dart';
import 'package:object_browser/table_dummy.dart';
//import 'dart:ffi' as ffi;
//import 'dart:io' show Platform, Directory;
//import 'package:path/path.dart' as path;

//table where current data gets stored
var objectDataTable = [];

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('ObjectBrowser'),
      ),

      body: SingleChildScrollView( // Avoid Render Overflow
        scrollDirection: Axis.vertical,
        child: Column(
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
        
                const SizedBox(width: 20), 
        
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
            
            // Add horizontal spacing
            const SizedBox(height: 20),
        
            // Two columns, one for tree and one for the table which should illustrate all objects
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
        
                const SizedBox(width: 20), // Adds horizontal space of 20 pixels
        
                //Tree Dummy
                Expanded(
                  child: SingleChildScrollView(
                    child: TreeViewWidget(),
                  ),
                ),

                const SizedBox(width: 20), // Adds horizontal space of 20 pixels

                //Dummy table
                TableDummy(), //Dummy table
        
                const SizedBox(width: 20), // Adds horizontal space of 20 pixels
        
              ],
            )
          ]
        ),
      ),
    );
  }
}