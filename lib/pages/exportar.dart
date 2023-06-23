// ignore_for_file: unused_import

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/functions.dart';
import 'package:projeto_prefeitura/main.dart';
import 'package:projeto_prefeitura/pages/exportar.dart';
import 'package:projeto_prefeitura/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: duplicate_import
import 'package:projeto_prefeitura/users.dart';

class Exportar extends StatefulWidget {
  const Exportar({super.key});

  @override
  State<Exportar> createState() => _Exportar();
}

class _Exportar extends State<Exportar> {
  final _firebaseAuth = FirebaseAuth.instance;
  String nome = '';
  String email = '';

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

  late List<Dados> dados;

  int? sortColumnIndex;

  bool isAscending = false;

  @override
  void initState() {
    super.initState();
    this.dados = List.of(allDados);
    chamarUsuario();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: appBarDinamica(),
      drawer: menuLateralDinamico(nome, email),
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
      rows: getRows(dados),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<Dados> dados) => dados.map((Dados dados) {
        final cells = [
          dados.SIAT,
          dados.nome,
          dados.cpf_cnpj,
          dados.rua,
          dados.numero_casa,
          dados.quarteirao,
          dados.data,
          dados.horas,
        ];
        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      dados.sort(
        (dados1, dados2) =>
            compareInt_siat(ascending, dados1.SIAT, dados2.SIAT),
      );
    } else if (columnIndex == 1) {
      dados.sort(
        (dados1, dados2) =>
            compareString_nome(ascending, dados1.nome, dados2.nome),
      );
    } else if (columnIndex == 2) {
      dados.sort(
        (dados1, dados2) =>
            compareString_cpf_cnpj(ascending, dados1.cpf_cnpj, dados2.cpf_cnpj),
      );
    } else if (columnIndex == 3) {
      dados.sort(
        (dados1, dados2) =>
            compareString_rua(ascending, dados1.rua, dados2.rua),
      );
    } else if (columnIndex == 4) {
      dados.sort(
        (dados1, dados2) => compareString_num(
            ascending, dados1.numero_casa, dados2.numero_casa),
      );
    } else if (columnIndex == 5) {
      dados.sort(
        (dados1, dados2) =>
            compareInt_quart(ascending, dados1.quarteirao, dados2.quarteirao),
      );
    } else if (columnIndex == 6) {
      dados.sort(
        (dados1, dados2) =>
            comapareString_data(ascending, dados1.data, dados2.data),
      );
    } else if (columnIndex == 7) {
      dados.sort(
        (dados1, dados2) =>
            comapareString_horario(ascending, dados1.horas, dados2.horas),
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

  chamarUsuario() async {
    User? usuario = await _firebaseAuth.currentUser;
    if (usuario != null) {
      print(usuario);
      setState(() {
        nome = usuario.displayName!;
        email = usuario.email!;
      });
    }
  }
}
