import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  List<List<dynamic>> data = [
    ['Name', 'Age', 'Location'],
    ['John', 25, 'New York'],
    ['Jane', 30, 'Los Angeles'],
    ['Bob', 22, 'Chicago'],
  ];

  Future<void> exportCSV(BuildContext context) async {
    String csv = const ListToCsvConverter().convert(data);
    final downloadsDirectory = Directory('/storage/emulated/0/Download');

    if (await downloadsDirectory.exists()) {
      final file = File('${downloadsDirectory.path}/exported_data.csv');
      await file.writeAsString(csv);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CSV file exported to Download folder'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error exporting CSV: Download directory does not exist'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Export Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => exportCSV(context),
          child: Text('Export CSV'),
        ),
      ),
    );
  }
}
