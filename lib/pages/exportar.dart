// ignore_for_file: unused_import

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/functions.dart';
import 'package:projeto_prefeitura/main.dart';
import 'package:projeto_prefeitura/pages/exportar.dart';

import 'package:projeto_prefeitura/users.dart';

class Exportar extends StatefulWidget {
  const Exportar({super.key});

  @override
  State<Exportar> createState() => _Exportar();
}

class _Exportar extends State<Exportar> {
  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              actions: [
                Espacamento10(),
                Center(
                  child: Text(
                    'Formato de Exportação',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Espacamento10(),
                Espacamento10(),
                Center(
                  child: ElevatedButton.icon(
                    style: raisedButtonStyle,
                    icon: Icon(Icons.download),
                    onPressed: () {},
                    label: Text('CSV'),
                  ),
                ),
                Espacamento5(),
                Center(
                  child: ElevatedButton.icon(
                    style: raisedButtonStyle,
                    icon: Icon(Icons.download),
                    onPressed: () {},
                    label: Text('TXT'),
                  ),
                ),
                Espacamento5(),
                Center(
                  child: ElevatedButton.icon(
                    style: raisedButtonStyle,
                    icon: Icon(Icons.download),
                    onPressed: () {},
                    label: Text('XML'),
                  ),
                ),
                Espacamento10()
              ]);
        });
  }

  late List<User> users;

  int? sortColumnIndex;

  bool isAscending = false;

  @override
  void initState() {
    super.initState();
    this.users = List.of(allUsers);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: appBarDinamica(),
      drawer: menuLateralDinamico(),
      body: Container(
        child: ListView(
          children: [
            Espacamento10(),
            Row(
              children: [
                SizedBox(width: 10),
                Container(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton.icon(
                    onPressed: _showDialog,
                    icon: Icon(Icons.import_export),
                    label: Text('Exportar'),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Color.fromARGB(221, 255, 255, 255),
                      primary: Color.fromARGB(191, 18, 108, 133),
                      minimumSize: Size(100, 45),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      textStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            Espacamento10(),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: buildDataTable(),
              ),
            ),
          ],
        ),
      ));

  Widget buildDataTable() {
    final columns = [
      'SIAT',
      'Nome',
      'CPF/CNPJ',
      'Rua',
      'Numero',
      'Quarteirão',
      'Data',
      'Horario',
    ];
    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(users),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<User> users) => users.map((User user) {
        final cells = [
          user.SIAT,
          user.nome,
          user.cpf_cnpj,
          user.rua,
          user.numero_casa,
          user.quarteirao,
          user.data,
          user.horas,
        ];
        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      users.sort(
        (user1, user2) => compareInt_siat(ascending, user1.SIAT, user2.SIAT),
      );
    } else if (columnIndex == 1) {
      users.sort(
        (user1, user2) => compareString_nome(ascending, user1.nome, user2.nome),
      );
    } else if (columnIndex == 2) {
      users.sort(
        (user1, user2) =>
            compareString_cpf_cnpj(ascending, user1.cpf_cnpj, user2.cpf_cnpj),
      );
    } else if (columnIndex == 3) {
      users.sort(
        (user1, user2) => compareString_rua(ascending, user1.rua, user2.rua),
      );
    } else if (columnIndex == 4) {
      users.sort(
        (user1, user2) =>
            compareString_num(ascending, user1.numero_casa, user2.numero_casa),
      );
    } else if (columnIndex == 5) {
      users.sort(
        (user1, user2) =>
            compareInt_quart(ascending, user1.quarteirao, user2.quarteirao),
      );
    } else if (columnIndex == 6) {
      users.sort(
        (user1, user2) =>
            comapareString_data(ascending, user1.data, user2.data),
      );
    } else if (columnIndex == 7) {
      users.sort(
        (user1, user2) =>
            comapareString_horario(ascending, user1.horas, user2.horas),
      );
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString_nome(bool ascending, String nome1, String nome2) =>
      ascending ? nome1.compareTo(nome2) : nome2.compareTo(nome1);

  int compareInt_siat(bool ascending, int siat1, int siat2) =>
      ascending ? siat1.compareTo(siat2) : siat2.compareTo(siat1);

  int compareString_cpf_cnpj(
          bool ascending, String cpf_cnpj1, String cpf_cnpj2) =>
      ascending
          ? cpf_cnpj1.compareTo(cpf_cnpj2)
          : cpf_cnpj2.compareTo(cpf_cnpj1);

  int compareString_rua(bool ascending, String rua1, String rua2) =>
      ascending ? rua1.compareTo(rua2) : rua2.compareTo(rua1);

  int compareString_num(
          bool ascending, String numero_casa1, String numero_casa2) =>
      ascending
          ? numero_casa1.compareTo(numero_casa2)
          : numero_casa2.compareTo(numero_casa1);

  int compareInt_quart(bool ascending, int quarteirao1, int quarteirao2) =>
      ascending
          ? quarteirao1.compareTo(quarteirao2)
          : quarteirao2.compareTo(quarteirao1);

  int comapareString_data(bool ascending, String data1, String data2) =>
      ascending ? data1.compareTo(data2) : data2.compareTo(data1);

  int comapareString_horario(bool ascending, String horas1, String horas2) =>
      ascending ? horas1.compareTo(horas2) : horas2.compareTo(horas1);
}

//personalização do botão
/*Text(
              'Formato de Exportação',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromARGB(190, 7, 62, 77),
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
            Espacamento5(),
            ElevatedButton.icon(
              style: raisedButtonStyle,
              icon: Icon(Icons.download),
              onPressed: () {},
              label: Text('CSV'),
            ),
            Espacamento10(),
            ElevatedButton.icon(
              style: raisedButtonStyle,
              icon: Icon(Icons.download),
              onPressed: () {},
              label: Text('TXT'),
            ),
            Espacamento10(),
            ElevatedButton.icon(
              style: raisedButtonStyle,
              icon: Icon(Icons.download),
              onPressed: () {},
              label: Text('XML'),
            ), */
