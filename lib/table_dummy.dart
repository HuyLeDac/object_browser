import 'package:flutter/material.dart';

class TableDummy extends StatelessWidget {
  const TableDummy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          const Text('Table'),
          DataTable(
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
            rows: List<DataRow>.generate(12, (index) => const DataRow(
              cells: [
                DataCell(Text('1180416')),
                DataCell(Text('cycle time')),
                DataCell(Text('5644645')),
                DataCell(Text('1180416')),
                DataCell(Text('cycle time')),
                DataCell(Text('5644645')),
                DataCell(Text('1180416')),
                DataCell(Text('cycle time')),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
