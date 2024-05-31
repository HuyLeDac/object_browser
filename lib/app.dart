import 'package:flutter/material.dart';
import 'package:object_browser/loading_dialogue.dart';
import 'package:object_browser/tree_node.dart';
import 'package:object_browser/table_dummy.dart';

// Table where current data gets stored
List<List<String>> objectDataTable = [];

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  void _updateDataTable(List<List<String>> newData) {
    setState(() {
      objectDataTable = newData;
    });
  }

  // Method to show the LoadingDialog and wait for it to complete
  Future<void> _showLoadingDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoadingDialog(onDataLoaded: _updateDataTable);
      },
    );
  }

  // Method to show another dialog after the LoadingDialog
  Future<void> _showSecondDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Loading complete'),
          content: const Text('This is the second dialog.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ObjectBrowser'),
        backgroundColor:const Color.fromRGBO(0, 157, 224, 1),
      ),
      body: SingleChildScrollView(
        // Avoid Render Overflow
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Row(
              // Load button, add other buttons later
              children: <Widget>[
                const SizedBox(width: 20), // Adds vertical space of 20 pixels

                ElevatedButton(
                  onPressed: () async {
                    await _showLoadingDialog(context);
                    await _showSecondDialog(context);
                  },
                  child: const Text('Load CNC objects'),
                ),

                const SizedBox(width: 20), // Adds vertical space of 20 pixels

                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LoadingDialog(onDataLoaded: (data) {}); // Dummy for modifying DLL paths
                      },
                    );
                  },
                  child: const Text('Modify DLL path'),
                ),

                const SizedBox(width: 20), // Adds veritcal space of 20 pixels

                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return  LoadingDialog(onDataLoaded: (data) {}); // Dummy for other buttons
                      },
                    );
                  },
                  child: const Text('...'),
                ),
              ],
            ),

            // Add horizontal spacing
            const SizedBox(height: 20),

            // Two columns, one for tree and one for the table which should illustrate all objects
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(width: 20), // Adds horizontal space of 20 pixels
                // Tree Dummy
                const Flexible(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: TreeViewWidget(),
                  ),
                ),
                const SizedBox(width: 20), // Adds horizontal space of 20 pixels
                // Dummy table
                Flexible(
                  flex: 4,
                  child: TableDummy(objectDataTable: objectDataTable),
                ),
                const SizedBox(width: 20), // Adds horizontal space of 20 pixels
              ],
            )
          ],
        ),
      ),
    );
  }
}

