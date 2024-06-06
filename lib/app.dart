import 'package:flutter/material.dart';
import 'package:object_browser/loading_dialog.dart';
import 'package:object_browser/tree_node.dart';
import 'package:object_browser/table_dummy.dart';

/// Assuming objTestPath is a global variable
/// Path for the dll
String objTestPath = 'C:/cnc_objects_test_dll/x64/Debug/ob_test_dll.dll';  

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final TextEditingController _pathController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Table where current data gets stored
  List<List<String>> objectDataTable = [];
  // port open and geoPlatformNumber
  int portOpen = -1;
  int geoPlatformNumber = -1;

  @override
  void initState() {
    super.initState();
    _pathController.text = objTestPath; // Initialize path with current path
  }

  // method to update the object data table 
  void _updateDataTable(List<List<String>> newData) {
    setState(() {
      objectDataTable = newData;
    });
  }

  // method for updating the port open value
  void _updatePortOpen(int newPortOpen) {
    setState(() {
      portOpen = newPortOpen;
    });
  }

  // update geoPlatformNumber 
  void _updateGeoPlatformNumber(int newGeoPlatformNumber) {
    setState(() {
      geoPlatformNumber = newGeoPlatformNumber;
    });
  }

  // method to show the LoadingDialog and wait for it to complete
  Future<void> _showLoadingDialog() async {
    await showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return LoadingDialog(
          onTableLoaded: _updateDataTable, 
          onPortOpenLoaded: _updatePortOpen, 
          onGeoPlatformLoaded: _updateGeoPlatformNumber,
        );
      },
    );
  }

  
  // method to open another path configuration (alert) dialog
  Future<void> _showChangePathDialog() async {
    await showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change dll path'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            // Widget consists of One Text Field and two buttons
            children: <Widget>[
              TextField(
                controller: _pathController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: objTestPath,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        objTestPath = _pathController.text;
                      });
                      Navigator.of(context).pop();
                      await _showLoadingDialog();
                    },
                    child: const Text('Save and reload'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar( // App bar
        title: const Text('ObjectBrowser'),
        backgroundColor: const Color.fromRGBO(0, 157, 224, 1),
      ),
      body: Container(
        child: LayoutBuilder( // Layout builder for dynamically resize widgets
          builder: (context, constraints) {
            var parentHeight = constraints.maxHeight;
            var parentWidth = constraints.maxWidth;
            debugPrint('Max height: $parentHeight, max width: $parentWidth');
            return SingleChildScrollView( // Make widget scrollable to avoid render overflow
              scrollDirection: Axis.vertical,
              child: Column(
                /// Widget consists of one Row with buttons 
                /// and one row consisting a toggle tree and a table  
                children: <Widget>[
                  const SizedBox(height: 20), 
                   
                  Row(  
                    children: <Widget>[
                      const SizedBox(width: 20), 
                      ElevatedButton( // Loading dialog button
                        onPressed: () async {
                          await _showLoadingDialog();
                        },
                        child: const Text('Load CNC objects'),
                      ),
                      const SizedBox(width: 20),  
                      ElevatedButton( // Path configuration button
                        onPressed: () async {
                          await _showChangePathDialog();
                        },
                        child: const Text('Modify DLL path'),
                      ),
                      const SizedBox(width: 20), 
                      ElevatedButton( // Dummy button (eventually add new buttons)
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return LoadingDialog(onTableLoaded: (data) {}, onPortOpenLoaded: (data) {}, onGeoPlatformLoaded: (data) {},); // Dummy for other buttons
                            },
                          );
                        },
                        child: const Text('...'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20), // Add space between both rows

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(width: 20), 
                      const Flexible( // Tree Dummy
                        flex: 1,
                        child: SingleChildScrollView(
                          child: TreeViewWidget(),
                        ),
                      ),
                      const SizedBox(width: 20), 
                      Flexible( // Dummy table for showing objects
                        flex: 5,
                        child: TableDummy(objectDataTable: objectDataTable, portOpen: portOpen, geoPlatformNumber: geoPlatformNumber,),
                      ),
                      
                      const SizedBox(width: 20), // Adds horizontal space of 20 pixels
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
