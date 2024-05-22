import 'package:flutter/material.dart';
import 'dart:ffi' as ffi;
import 'dart:ffi';
//import 'dart:io' show Platform, Directory;
//import 'package:path/path.dart' as path;
import 'package:object_browser/ads_def.dart';


// Path to ob_test_dll.dll
String objTestPath = 'assets/cnc_objects_test_dll/x64/Debug/ob_test_dll.dll'; 
// Open dynamic library that contains methods.
final dylibObjTestDll = ffi.DynamicLibrary.open(objTestPath); 

// Get functions from dll.
final int Function() portOpen = dylibObjTestDll.lookup<NativeFunction<Int64 Function()>>('port_open').asFunction();
final int Function() portClose = dylibObjTestDll.lookup<NativeFunction<Int64 Function()>>('port_open').asFunction();
//final int Function(Pointer<AmsAddr> pServerAddr, Uint32 indexGroup, Uint32 indexOffset, Uint32 length, Pointer<Void> pData) readReq =
//    dylibObjTestDll.lookup<NativeFunction<Int64 Function(ffi.Pointer<AmsAddr> pServerAddr, ffi.Uint32 indexGroup, ffi.Uint32 indexOffset, ffi.Uint32 length, ffi.Pointer<ffi.Void> pData)>>('read_req').asFunction();



class LoadingDialog extends StatefulWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  
  double _progressValue = 0.0;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadData();
    print(portOpen());
    print(portClose());
  }

  // Simulate loading data
  void _loadData() {
    setState(() {
      _isLoading = true;
      _progressValue = 0.0; // Reset progress value
    });

    const int totalSteps = 100;
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
    Future.delayed(const Duration(milliseconds: (totalSteps + 1) * delayMilliseconds + 200), () {
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
              const Text('Loading...')
            else
              const Text('Loading complete'), // Show completion message when loading is complete
          ],
        ),
      ),
    );
  }
}