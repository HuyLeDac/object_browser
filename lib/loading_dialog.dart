import 'package:flutter/material.dart';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:object_browser/type_def.dart';
import 'package:object_browser/app.dart';
import 'package:enough_convert/enough_convert.dart';

typedef DataCallbackTable = void Function(List<List<String>>);
typedef DataCallbackPortOpen = void Function(int);
typedef DataCallbackGeoPlatform = void Function(int);

final dylibObjTestDll = ffi.DynamicLibrary.open(objTestPath); 

final int Function() portOpenFunc = dylibObjTestDll.lookup<NativeFunction<Int64 Function()>>('port_open').asFunction();
final int Function() portCloseFunc = dylibObjTestDll.lookup<NativeFunction<Int64 Function()>>('port_close').asFunction();
final int Function(Pointer<AmsAddr> pServerAddr, int indexGroup, int indexOffset, int length, Pointer<Void> pData) readReq =
    dylibObjTestDll.lookup<NativeFunction<Int64 Function(Pointer<AmsAddr> pServerAddr, UnsignedLong indexGroup, UnsignedLong indexOffset, UnsignedLong length, Pointer<Void> pData)>>('read_req').asFunction();
final int Function(Pointer<AmsAddr> pServerAddr) getGeoPlatformNumber = 
    dylibObjTestDll.lookup<NativeFunction<Int32 Function(Pointer<AmsAddr> pServerAddr)>>('get_geo_platform_number').asFunction();
final Pointer<CNCObject> Function(Pointer<AmsAddr> pServerAddr, int index) getGeoPlatformObjectAt = 
    dylibObjTestDll.lookup<NativeFunction<Pointer<CNCObject> Function(Pointer<AmsAddr> pServerAddr, UnsignedInt index)>>('get_geo_platform_object_at').asFunction();


//Initialize PortOpen and PortClose and geoPlatformNumber
  var portOpen = -1;
  var portClose = -1;
  var geoPlatformNumber = -1;

class LoadingDialog extends StatefulWidget {
  final DataCallbackTable onDataLoaded;
  final DataCallbackPortOpen onPortOpenLoaded;
  final DataCallbackGeoPlatform onGeoPlatformLoaded;

  const LoadingDialog({Key? key, required this.onDataLoaded, 
                                  required this.onPortOpenLoaded,
                                  required this.onGeoPlatformLoaded}) : super(key: key);

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  double _progressValue = 0.0;
  bool _isLoading = false;

   // Allocate memory for AmsAddr and AmsNetId
  final pServerAddr = calloc.allocate<AmsAddr>(1);
  final pNetId = calloc.allocate<AmsNetId>(1);


  @override
  void initState() {
    super.initState();

    // Initialize dummy pServerAddr and pNetId
    // Initialize the netId
    pNetId.ref.b[0] = 1;
    pNetId.ref.b[1] = 2;
    pNetId.ref.b[2] = 3;
    pNetId.ref.b[3] = 4;
    pNetId.ref.b[4] = 5;
    pNetId.ref.b[5] = 6;
    // Assign the netId to pServerAddr
    pServerAddr.ref.netId = pNetId.ref;
    // Initialize dummy port
    pServerAddr.ref.port = 851;

    portOpen = portOpenFunc();
    portClose = portCloseFunc();
    print('Port open: $portOpen');
    //print('Port close: $portClose');
    print('pServerAddr: netId: ${pServerAddr.ref.netId.b.toString()}, port: ${pServerAddr.ref.port}');

    _loadData();
  }

  // Simulate loading data
  void _loadData() async {
    setState(() {
      _isLoading = true;
      _progressValue = 0.0;
    });

    // TODO: 0 gets printed sometimes, fix issue later 
    int totalSteps = 0;
    while(totalSteps == 0){
      totalSteps = getGeoPlatformNumber(pServerAddr);
    }
    
    print('Geo platform number: $totalSteps');



    List<List<String>> newData = List.generate(totalSteps, (_) => []);

    // Simulate loading bar progress
    for (int i = 0; i < totalSteps; i++) {
      await Future.delayed(const Duration(milliseconds: 50), () {

        // Get current CNC Object from dll
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
        print('\nCurrent index: $i');
        print('Group: ${newData[i][0]}, Offset: ${newData[i][1]}, name: ${newData[i][2]}, Data Type: ${newData[i][3]}, Length: ${newData[i][4]}, unit: ${newData[i][5]}, Cvalue: ${newData[i][6]}, Value: ${newData[i][7]}\n');

        setState(() {
          _progressValue = i / totalSteps;
        });
      });
    }

    widget.onDataLoaded(newData);
    widget.onPortOpenLoaded(portOpen);
    widget.onGeoPlatformLoaded(totalSteps);

    setState(() {
      _isLoading = false;
    });

    await Future.delayed(const Duration(milliseconds: 3000), () {
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
            _isLoading ? const Text('Loading CNC objects...') : const Text('Loading complete'), 
            const SizedBox(height: 20), // gap between widgets
            // show port open/close and geoPlatformNumber
            if (!_isLoading)
              Text('Port open: $portOpen \nPort close: $portClose \nGEO Platform Number: $geoPlatformNumber'), 
          ],
        ),
      ),
    );
  }

  //Convert cp1252 into Utf8
  String convertNameFromCp1252ToUtf8String(CNCObject object){
    const codec = Windows1252Codec(allowInvalid: false);
    List<int> name = [];
    
    for(int i=0; i < 256; i++){
      if(object.name[i] == 0){
        break;
      }
      name.add(object.name[i]);
    }
    
    return codec.decode(name);
  }

  String convertUnitFromCp1252ToUtf8String(CNCObject object){
    const codec = Windows1252Codec(allowInvalid: false);
    List<int> unitUtf8 = [];
    
    for(int i=0; i < 256; i++){
      if(object.unit[i] == 0){
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

  // Function to get the string representation of CNCObjectType
  String getCNCObjectTypeString(int dataType) {
    return cncObjectTypeToString[CNCObjectType.values[dataType]] ?? 'Unknown';
  }

  @override
  void dispose() {
    calloc.free(pServerAddr);
    calloc.free(pNetId);
    super.dispose();
  }

}

