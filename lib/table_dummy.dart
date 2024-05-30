import 'package:flutter/material.dart';

class TableDummy extends StatelessWidget {
  final List<List<String>> objectDataTable;

  const TableDummy({Key? key, required this.objectDataTable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          const Text('Table'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nr:')),
                DataColumn(label: Text('Gruppe')),
                DataColumn(label: Text('Offset:')),
                DataColumn(label: Text('Bezeichner:')),
                DataColumn(label: Text('Datentyp:')),
                DataColumn(label: Text('Länge:')),
                DataColumn(label: Text('Einheit:')),
                DataColumn(label: Text('Wert:')),
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
