import 'package:flutter/material.dart';

class TableDummy extends StatelessWidget {
  final List<List<String>> objectDataTable;
  final int portOpen;
  final int geoPlatformNumber;
  final double fontSize;

  const TableDummy({
    Key? key, 
    required this.objectDataTable, 
    required this.portOpen, 
    required this.geoPlatformNumber,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          const Text('CNC Objects table'),
          Text('Port Open: $portOpen'),
          Text('Geo Platform Number: $geoPlatformNumber'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Gruppe', style: TextStyle(fontSize: fontSize))),
                DataColumn(label: Text('Offset:', style: TextStyle(fontSize: fontSize))),
                DataColumn(label: Text('Name/Bezeichner:', style: TextStyle(fontSize: fontSize))),
                DataColumn(label: Text('Datentyp:', style: TextStyle(fontSize: fontSize))),
                DataColumn(label: Text('Länge:', style: TextStyle(fontSize: fontSize))),
                DataColumn(label: Text('Einheit:', style: TextStyle(fontSize: fontSize))),
                DataColumn(label: Text('cValue:', style: TextStyle(fontSize: fontSize))),
                DataColumn(label: Text('pValue:', style: TextStyle(fontSize: fontSize))),
              ],
              rows: List<DataRow>.generate(
                objectDataTable.length,
                (index) => DataRow(
                  cells: [
                    DataCell(Text(objectDataTable[index][0], style: TextStyle(fontSize: fontSize))),
                    DataCell(Text(objectDataTable[index][1], style: TextStyle(fontSize: fontSize))),
                    DataCell(Text(objectDataTable[index][2], style: TextStyle(fontSize: fontSize))),
                    DataCell(Text(objectDataTable[index][3], style: TextStyle(fontSize: fontSize))),
                    DataCell(Text(objectDataTable[index][4], style: TextStyle(fontSize: fontSize))),
                    DataCell(Text(objectDataTable[index][5], style: TextStyle(fontSize: fontSize))),
                    DataCell(Text(objectDataTable[index][6], style: TextStyle(fontSize: fontSize))),
                    DataCell(Text(objectDataTable[index][7], style: TextStyle(fontSize: fontSize))),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
