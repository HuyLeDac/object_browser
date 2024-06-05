import 'package:flutter/material.dart';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:object_browser/type_def.dart';
import 'package:object_browser/app.dart';
import 'package:enough_convert/enough_convert.dart';
import 'dart:async';


typedef DataCallbackTable = void Function(List<List<String>>);
typedef DataCallbackPortOpen = void Function(int);
typedef DataCallbackGeoPlatform = void Function(int);

// Open dll path
final dylibObjTestDll = ffi.DynamicLibrary.open(objTestPath);

// Get function defined in dll
final int Function() portOpenFunc = dylibObjTestDll.lookup<NativeFunction<Int64 Function()>>('port_open').asFunction();
final int Function() portCloseFunc = dylibObjTestDll.lookup<NativeFunction<Int64 Function()>>('port_close').asFunction();
final int Function(Pointer<AmsAddr> pServerAddr, int indexGroup, int indexOffset, int length, Pointer<Void> pData) readReq =
    dylibObjTestDll.lookup<NativeFunction<Int64 Function(Pointer<AmsAddr> pServerAddr, UnsignedLong indexGroup, UnsignedLong indexOffset, UnsignedLong length, Pointer<Void> pData)>>('read_req').asFunction();
final int Function(Pointer<AmsAddr> pServerAddr) getGeoPlatformNumber =
    dylibObjTestDll.lookup<NativeFunction<Int32 Function(Pointer<AmsAddr> pServerAddr)>>('get_geo_platform_number').asFunction();
final Pointer<CNCObject> Function(Pointer<AmsAddr> pServerAddr, int index) getGeoPlatformObjectAt =
    dylibObjTestDll.lookup<NativeFunction<Pointer<CNCObject> Function(Pointer<AmsAddr> pServerAddr, UnsignedInt index)>>('get_geo_platform_object_at').asFunction();

// Class responsible for updating data and saving them into different attributes which can be used in the app
class LoadingDialog extends StatefulWidget {

  // Callback functions to be called when specific events occur during the loading process
  final DataCallbackTable onTableLoaded; 
  final DataCallbackPortOpen onPortOpenLoaded;
  final DataCallbackGeoPlatform onGeoPlatformLoaded;

  const LoadingDialog({
    Key? key,
    required this.onTableLoaded,
    required this.onPortOpenLoaded,
    required this.onGeoPlatformLoaded,
  }) : super(key: key);

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {

  /// Initialize variables
  ///   _progressValue: Percentage illustrating loading progress
  ///   _isLoading: Indicates if the progress bar is still active
  ///   _loadingCompleter: handle asynchronous completion of loading process in the LoadingDialog widget.
  double _progressValue = 0.0;
  bool _isLoading = false;
  late int portOpen;
  late int portClose;
  late int geoPlatformNumber;
  final Completer<void> _loadingCompleter = Completer<void>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Allocate memory for AmsAddr and AmsNetId
  final pServerAddr = calloc.allocate<AmsAddr>(1);
  final pNetId = calloc.allocate<AmsNetId>(1);

  @override
  void initState() {
    super.initState();

    // Initialize dummy pServerAddr and pNetId
    pNetId.ref.b[0] = 1;
    pNetId.ref.b[1] = 2;
    pNetId.ref.b[2] = 3;
    pNetId.ref.b[3] = 4;
    pNetId.ref.b[4] = 5;
    pNetId.ref.b[5] = 6;
    pServerAddr.ref.netId = pNetId.ref;
    pServerAddr.ref.port = 851;

    portOpen = portOpenFunc();
    portClose = portCloseFunc();
    debugPrint('Port open: $portOpen');
    debugPrint('pServerAddr: netId: ${pServerAddr.ref.netId.b.toString()}, port: ${pServerAddr.ref.port}');

    _loadData();
  }

  // Simulate loading data
  void _loadData() async {
    setState(() {
      _isLoading = true;
      _progressValue = 0.0;
    });

    // Get geoPlatformNumber (number of existing objects)
    int totalSteps = 0;
    while (totalSteps == 0) {
      totalSteps = getGeoPlatformNumber(pServerAddr); // TODO: 0 gets printed sometimes, fix issue later
    }
    debugPrint('Geo platform number: $totalSteps');

    // Genereate empty list for the new data
    List<List<String>> newData = List.generate(totalSteps, (_) => []);

    // Simulate loading bar progress by iterating though every object 
    for (int i = 0; i < totalSteps; i++) {

      /// In case of asynchronous loading completion (e.g. tapping outside the loading bar)
      /// cancel loading progress
      if (_loadingCompleter.isCompleted) {
        break;
      }

      // Add small delay since it's needed for loading bar
      await Future.delayed(const Duration(milliseconds: 50), () {
        if (_loadingCompleter.isCompleted) {
          return;
        }

        // Get current CNC Object from dll with index and put them into newData
        CNCObject object = getGeoPlatformObjectAt(pServerAddr, i).ref;

        String group = toHexString(object.group);
        String offset = toHexString(object.offset);
        String name = convertNameFromCp1252ToUtf8String(object);
        String dataType = object.dataType.toString();
        String length = object.length.toString();
        String unit = convertUnitFromCp1252ToUtf8String(object);
        String cValue = object.cValue.toString();
        String value = object.value.toString();

        newData[i].add(group);
        newData[i].add(offset);
        newData[i].add(name);
        newData[i].add(dataType);
        newData[i].add(length);
        newData[i].add(unit);
        newData[i].add(cValue);
        newData[i].add(value);

        // Print cnc object
        debugPrint('\nCurrent index: $i');
        debugPrint('Group: ${newData[i][0]}, Offset: ${newData[i][1]}, name: ${newData[i][2]}, Data Type: ${newData[i][3]}, Length: ${newData[i][4]}, unit: ${newData[i][5]}, Cvalue: ${newData[i][6]}, Value: ${newData[i][7]}\n');

        // Only change state if widget is still mounted (to avoid memory leak)
        if (mounted) {
          setState(() {
            _progressValue = i / totalSteps;
          });
        }
      });
    }

    // Check if loading progress was interrupted
    if (!_loadingCompleter.isCompleted) {

      // Pass data to current parent widget
      widget.onTableLoaded(newData);
      widget.onPortOpenLoaded(portOpen);
      widget.onGeoPlatformLoaded(totalSteps);

      // Mark that loading progress is finished
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      // Wait 3 seconds before closing the dialog
      await Future.delayed(const Duration(milliseconds: 3000), () {
        if (mounted) {
          Navigator.of(context).pop(); // Close dialog when loading is completed
        }
      });

      _showLoadingCompletionDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Warp around a gesture detector which marks the process as completed when specific gestures (e.g. tap)
    ///   All processe will then be cancled since _loadingCompleter.isCompleted will be set true.
    return GestureDetector(
      onTap: () {
        if (!_loadingCompleter.isCompleted) {
          _loadingCompleter.complete();
        }
        Navigator.of(context).pop(); // Close the dialog
      },
      child: Dialog(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          /// Structure of the progress bar
          ///   LinearProgressIndicator: progress bar
          ///   Texts for showing the user if it's still loading
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LinearProgressIndicator(value: _progressValue, minHeight: 10,),
              const SizedBox(height: 20), // gap between widgets
              _isLoading ? const Text('Loading CNC objects...') : const Text('Loading complete'),
              const SizedBox(height: 20), // gap between widgets
              if (!_isLoading)
                Text('Port open: $portOpen \nPort close: $portClose \nGEO Platform Number: $geoPlatformNumber'),
            ],
          ),
        ),
      ),
    );
  }

  // Convert name encoding cp1252 into Utf8
  String convertNameFromCp1252ToUtf8String(CNCObject object) {
    const codec = Windows1252Codec(allowInvalid: false);
    List<int> name = [];

    for (int i = 0; i < 256; i++) {
      if (object.name[i] == 0) {
        break;
      }
      name.add(object.name[i]);
    }

    return codec.decode(name);
  }

  // Convert unit encoding cp1252 into Utf8
  String convertUnitFromCp1252ToUtf8String(CNCObject object) {
    const codec = Windows1252Codec(allowInvalid: false);
    List<int> unitUtf8 = [];

    for (int i = 0; i < 256; i++) {
      if (object.unit[i] == 0) {
        break;
      }
      unitUtf8.add(object.unit[i]);
    }

    return codec.decode(unitUtf8);
  }

  // Helper function to convert numbers to hexadecimal strings
  String toHexString(int number) {
    return '0x${number.toRadixString(16).toUpperCase()}';
  }

  // Method to show another dialog after the LoadingDialog
  Future<void> _showLoadingCompletionDialog() async {
    await showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Loading complete'),
          content: const Text('Content got updated.'),
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
  void dispose() {
    _loadingCompleter.complete();
    calloc.free(pServerAddr);
    calloc.free(pNetId);
    super.dispose();
  }
}