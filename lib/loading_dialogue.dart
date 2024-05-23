import 'package:flutter/material.dart';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:object_browser/type_def.dart';
//import 'dart:io' show Platform, Directory;
//import 'package:path/path.dart' as path;


// Path to ob_test_dll.dll, Open dynamic library. 
String objTestPath = 'C:/cnc_objects_test_dll/x64/Debug/ob_test_dll.dll'; 
final dylibObjTestDll = ffi.DynamicLibrary.open(objTestPath); 

// Get functions from dll.
final int Function() portOpenFunc = 
    dylibObjTestDll.lookup<NativeFunction<Int64 Function()>>('port_open').asFunction();
final int Function() portCloseFunc = 
    dylibObjTestDll.lookup<NativeFunction<Int64 Function()>>('port_close').asFunction();
final int Function(Pointer<AmsAddr> pServerAddr, int indexGroup, int indexOffset, int length, Pointer<Void> pData) readReq =
    dylibObjTestDll.lookup<NativeFunction<Int64 Function(Pointer<AmsAddr> pServerAddr, UnsignedLong indexGroup, UnsignedLong indexOffset, UnsignedLong length, Pointer<Void> pData)>>('read_req').asFunction();
final int Function(Pointer<AmsAddr> pServerAddr) getGeoPlatformNumber = 
    dylibObjTestDll.lookup<NativeFunction<Int32 Function(Pointer<AmsAddr> pServerAddr)>>('get_geo_platform_number').asFunction();
final Pointer<CNCObject> Function(Pointer<AmsAddr> pServerAddr, int index) getGeoPlatformObjectAt = 
    dylibObjTestDll.lookup<NativeFunction<Pointer<CNCObject> Function(Pointer<AmsAddr> pServerAddr, UnsignedInt index)>>('get_geo_platform_object_at').asFunction();



class LoadingDialog extends StatefulWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  
  //Values for Progress bar
  double _progressValue = 0.0;
  bool _isLoading = false;

  // Allocate memory for AmsAddr and AmsNetId
  final pServerAddr = calloc.allocate<AmsAddr>(1);
  final pNetId = calloc.allocate<AmsNetId>(1);

  //Initialize PortOpen and PortClose and geoPlatformNumber
  var portOpen = 'Failed to retrieve port open!';
  var portClose = 'Failed to retrieve port close!';
  var geoPlatformNumber = -1;

  @override
  void initState() {
    super.initState();
    _loadData();
  
    // Initialize pServerAddr and pNetId
    // Initialize the netId
    pNetId.ref.b[0] = 1;
    pNetId.ref.b[1] = 2;
    pNetId.ref.b[2] = 3;
    pNetId.ref.b[3] = 4;
    pNetId.ref.b[4] = 5;
    pNetId.ref.b[5] = 6;
    // Assign the netId to pServerAddr
    pServerAddr.ref.netId = pNetId.ref;
    // Initialize the port
    pServerAddr.ref.port = 851;

    geoPlatformNumber = getGeoPlatformNumber(pServerAddr);
    portOpen ='Port open: ${portOpenFunc()}';
    portClose = 'Port close: ${portCloseFunc()}';

    calloc.free(pServerAddr);
    calloc.free(pNetId);
  }

  // Simulate loading data
  void _loadData() {
    setState(() {
      _isLoading = true;
      _progressValue = 0.0; // Reset progress value
    });

    final int totalSteps = getGeoPlatformNumber(pServerAddr);
    const int delayMilliseconds = 50; // Adjust the delay time as needed
    
    //simulate 
    for (int i = 0; i <= totalSteps; i++) {
      Future.delayed(Duration(milliseconds: i * delayMilliseconds), () {
        setState(() {
          _progressValue = i / totalSteps;
        });
      });
    }

    // Simulate loading completion
    Future.delayed(Duration(milliseconds: (totalSteps + 1) * delayMilliseconds), () {
      setState(() {
        _isLoading = false; // Set isLoading to false when loading is completed
      });

      Navigator.of(context).pop(); // Close dialog when loading is completed
    });


  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LinearProgressIndicator(
              value: _progressValue,
              minHeight: 10,
            ),

            const SizedBox(height: 20),
            if (_isLoading)
              const Text('Loading CNC objects...')
            else
              const Text('Loading complete'), // Show completion message when loading is complete

            const SizedBox(height: 20),
            if (!_isLoading)
              Text('$portOpen \n $portClose \n GEO Platform Number: $geoPlatformNumber'), 
          ],
        ),
      ),
    );
  }
}