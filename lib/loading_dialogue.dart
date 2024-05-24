import 'package:flutter/material.dart';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:object_browser/type_def.dart';
//import 'dart:io' show Platform, Directory;
//import 'package:path/path.dart' as path;


/* Path to ob_test_dll.dll, Open dynamic library. */ 
String objTestPath = 'C:/cnc_objects_test_dll/x64/Debug/ob_test_dll.dll'; 
final dylibObjTestDll = ffi.DynamicLibrary.open(objTestPath); 

/* Get functions from dll. */
// port_open
final int Function() portOpenFunc = 
    dylibObjTestDll.lookup<NativeFunction<Int64 Function()>>('port_open').asFunction();
// port_close
final int Function() portCloseFunc = 
    dylibObjTestDll.lookup<NativeFunction<Int64 Function()>>('port_close').asFunction();
// read_req
final int Function(Pointer<AmsAddr> pServerAddr, int indexGroup, int indexOffset, int length, Pointer<Void> pData) readReq =
    dylibObjTestDll.lookup<NativeFunction<Int64 Function(Pointer<AmsAddr> pServerAddr, UnsignedLong indexGroup, UnsignedLong indexOffset, UnsignedLong length, Pointer<Void> pData)>>('read_req').asFunction();
// get_geo_platform_number
final int Function(Pointer<AmsAddr> pServerAddr) getGeoPlatformNumber = 
    dylibObjTestDll.lookup<NativeFunction<Int32 Function(Pointer<AmsAddr> pServerAddr)>>('get_geo_platform_number').asFunction();
// get_geo_platform_object_at
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
  var portOpen = -1;
  var portClose = -1;
  var geoPlatformNumber = -1;

  @override
  void initState() {
    super.initState();
  
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
    portOpen = portOpenFunc();
    portClose = portCloseFunc();
    print('Port open: $portOpen');
    print('Port close: $portClose');
    print('Geo platform number: $geoPlatformNumber');
    print('pServerAddr: netId: ${pServerAddr.ref.netId}, port: ${pServerAddr.ref.port}');
    

    // load data
    _loadData();
  }

  // Simulate loading data
  void _loadData() async {
    setState(() {
      _isLoading = true;
      _progressValue = 0.0; // Reset progress value
    });

    final int totalSteps = getGeoPlatformNumber(pServerAddr);
    
    
    // Simulate loading bar progress
    for (int i = 0; i < totalSteps; i++) {
      await Future.delayed(const Duration(milliseconds: 50), () {
        // Print cnc object
        CNCObject object = getGeoPlatformObjectAt(pServerAddr, i).ref;
        print('Current index: $i');
        print('Group: ${object.group}, Offset: ${object.offset}, name: ${object.name}, Data Type: ${object.dataType}, Length: ${object.length}, unit: ${object.unit}, Cvalue: ${object.cValue}, Value: ${object.value}');

        setState(() {
          _progressValue = i / totalSteps;
        });
      });
    }


    // Simulate loading completion
    await Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _isLoading = false; // Set isLoading to false when loading is completed
      });
    });

    await Future.delayed(const Duration(milliseconds: 4000), () {
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
            
            // Progress bar
            LinearProgressIndicator(
              value: _progressValue,
              minHeight: 10,
            ),

            const SizedBox(height: 20), // gap between widgets

            // Text for indicating, if the objects are still loading
            if (_isLoading)
              const Text('Loading CNC objects...')
            else
              const Text('Loading complete'), 

            const SizedBox(height: 20), // gap between widgets

            // show port open/close and geoPlatformNumber
            if (!_isLoading)
              Text('Port open: $portOpen \nPort close: $portClose \nGEO Platform Number: $geoPlatformNumber'), 
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    calloc.free(pServerAddr);
    calloc.free(pNetId);
    super.dispose();
  }

}