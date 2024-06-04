import 'package:flutter/material.dart';

class TableDummy extends StatelessWidget {
  final List<List<String>> objectDataTable;
  final int portOpen;
  final int geoPlatformNumber;

  const TableDummy({Key? key, required this.objectDataTable, required this.portOpen, required this.geoPlatformNumber}) : super(key: key);

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
              columns: const [
                DataColumn(label: Text('Gruppe')),
                DataColumn(label: Text('Offset:')),
                DataColumn(label: Text('Name/Bezeichner:')),
                DataColumn(label: Text('Datentyp:')),
                DataColumn(label: Text('Länge:')),
                DataColumn(label: Text('Einheit:')),
                DataColumn(label: Text('cValue:')),
                DataColumn(label: Text('pValue:')),
              ],
              rows: List<DataRow>.generate(
                objectDataTable.length,
                (index) => DataRow(
                  cells: [
                    DataCell(Text(objectDataTable[index][0])),
                    DataCell(Text(objectDataTable[index][1])),
                    DataCell(Text(objectDataTable[index][2])),
                    DataCell(Text(objectDataTable[index][3])),
                    DataCell(Text(objectDataTable[index][4])),
                    DataCell(Text(objectDataTable[index][5])),
                    DataCell(Text(objectDataTable[index][6])),
                    DataCell(Text(objectDataTable[index][7])),

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
