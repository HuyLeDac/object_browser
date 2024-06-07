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
  final TextEditingController _treeFontSizeController = TextEditingController();
  final TextEditingController _tableFontSizeController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Table where current data gets stored
  List<List<String>> objectDataTable = [];
  
  // port open and geoPlatformNumber
  int portOpen = -1;
  int geoPlatformNumber = -1;

  // Font size for the tree and table
  double _treeFontSize = 14.0;
  double _tableFontSize = 14.0;

  @override
  void initState() {
    super.initState();
    _pathController.text = objTestPath; // Initialize path with current path
    _treeFontSizeController.text = _treeFontSize.toString(); // Initialize tree font size
    _tableFontSizeController.text = _tableFontSize.toString(); // Initialize table font size
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

  // method to open a dialog for changing the tree font size
  Future<void> _changeTreeFontSizeDialog() async {
    await showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Tree Font Size'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _treeFontSizeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: _treeFontSize.toString(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        double newFontSize = double.tryParse(_treeFontSizeController.text) ?? 14.0;
                        _treeFontSize = newFontSize;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
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

  // method to open a dialog for changing the table font size
  Future<void> _changeTableFontSizeDialog() async {
    await showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Table Font Size'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _tableFontSizeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: _tableFontSize.toString(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        double newFontSize = double.tryParse(_tableFontSizeController.text) ?? 14.0;
                        _tableFontSize = newFontSize;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
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
                children: <Widget>[
                  const SizedBox(height: 20), 
                  
                  // One row with buttons 
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(  
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
                        ElevatedButton( // Tree font size button
                          onPressed: () async {
                            await _changeTreeFontSizeDialog();
                          },
                          child: const Text('Change Tree Font Size'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton( // Table font size button
                          onPressed: () async {
                            await _changeTableFontSizeDialog();
                          },
                          child: const Text('Change Table Font Size'),
                        ),
                        const SizedBox(width: 20), 
                        ElevatedButton( // Dummy button (eventually add new buttons)
                          onPressed: () {
                            // ...
                          },
                          child: const Text('...'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20), // Add space between both rows

                  // One row consisting a toggle tree and a table  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(width: 20), 
                      Flexible( // Tree Dummy
                        flex: 1,
                        child: SingleChildScrollView(
                          child: TreeViewWidget(fontSize: _treeFontSize),
                        ),
                      ),
                      const SizedBox(width: 20), 
                      Flexible( // Dummy table for showing objects
                        flex: 5,
                        child: TableDummy(
                          objectDataTable: objectDataTable, 
                          portOpen: portOpen, 
                          geoPlatformNumber: geoPlatformNumber, 
                          fontSize: _tableFontSize,
                        ),
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
