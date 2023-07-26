import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_prefeitura/functions.dart';
import 'dart:async';

class Dados {
  final int SIAT;
  final String nome;
  final String cpf_cnpj;
  final String rua;
  final String numero_casa;
  final int quarteirao;
  final String data;
  final String horas;

  const Dados({
    required this.SIAT,
    required this.nome,
    required this.cpf_cnpj,
    required this.rua,
    required this.numero_casa,
    required this.quarteirao,
    required this.data,
    required this.horas,
  });

  Dados copy({
    int? SIAT,
    String? nome,
    String? cpf_cnpj,
    String? rua,
    String? numero_casa,
    int? quarteirao,
    String? data,
    String? horas,
  }) =>
      Dados(
        SIAT: SIAT ?? this.SIAT,
        nome: nome ?? this.nome,
        cpf_cnpj: cpf_cnpj ?? this.cpf_cnpj,
        rua: rua ?? this.rua,
        numero_casa: numero_casa ?? this.numero_casa,
        quarteirao: quarteirao ?? this.quarteirao,
        data: data ?? this.data,
        horas: horas ?? this.horas,
      );
}

class ExportarPage extends StatefulWidget {
  const ExportarPage({Key? key}) : super(key: key);

  @override
  State<ExportarPage> createState() => ExportarState();
}

class ExportarState extends State<ExportarPage> {
  final _firebaseAuth = FirebaseAuth.instance;
  String nome = '';
  String email = '';

  late StreamSubscription<DatabaseEvent> _dadosSubscription;
  late StreamController<List<Dados>> _dadosController;

  List<Dados> dados = [];
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();
    _dadosController = StreamController<List<Dados>>();
    buscarDadosEmTempoReal();
    chamarUsuario();
  }

  @override
  void dispose() {
    _dadosSubscription.cancel();
    _dadosController.close();
    super.dispose();
  }

  void buscarDadosEmTempoReal() {
    final databaseReference =
        FirebaseDatabase.instance.reference().child('imoveis');

    _dadosSubscription = databaseReference.onValue.listen((event) {
      final dynamic data = event.snapshot.value;
      if (data != null && data is Map<dynamic, dynamic>) {
        List<Dados> dadosList = [];
        data.forEach((key, value) {
          dadosList.add(Dados(
            SIAT: value['Inscrição Siat'],
            nome: value['Nome'],
            cpf_cnpj: value['CPF'],
            rua: value['Rua'],
            numero_casa: value['Nº'],
            quarteirao: value['Quarteirão'],
            data: value['Data 1'],
            horas: value['Horario 1'],
          ));
        });

        setState(() {
          dados = dadosList;
        });
      }
    }, onError: (error) {
      print('Error fetching data: $error');
    });
  }

  // Restante do código

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
                  child: StreamBuilder<List<Dados>>(
                    stream: _dadosController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        dados = snapshot.data!;
                        return buildDataTable();
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );

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
      rows: getRows(),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows() => dados.map((Dados dados) {
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
    switch (columnIndex) {
      case 0:
        dados.sort((dados1, dados2) =>
            compareInt_siat(ascending, dados1.SIAT, dados2.SIAT));
        break;
      case 1:
        dados.sort((dados1, dados2) =>
            compareString_nome(ascending, dados1.nome, dados2.nome));
        break;
      case 2:
        dados.sort((dados1, dados2) => compareString_cpf_cnpj(
            ascending, dados1.cpf_cnpj, dados2.cpf_cnpj));
        break;
      case 3:
        dados.sort((dados1, dados2) =>
            compareString_rua(ascending, dados1.rua, dados2.rua));
        break;
      case 4:
        dados.sort((dados1, dados2) => compareString_num(
            ascending, dados1.numero_casa, dados2.numero_casa));
        break;
      case 5:
        dados.sort((dados1, dados2) =>
            compareInt_quart(ascending, dados1.quarteirao, dados2.quarteirao));
        break;
      case 6:
        dados.sort((dados1, dados2) =>
            compareString_data(ascending, dados1.data, dados2.data));
        break;
      case 7:
        dados.sort((dados1, dados2) =>
            compareString_horario(ascending, dados1.horas, dados2.horas));
        break;
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
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

  int compareString_data(bool ascending, String data1, String data2) =>
      ascending ? data1.compareTo(data2) : data2.compareTo(data1);

  int compareString_horario(bool ascending, String horas1, String horas2) =>
      ascending ? horas1.compareTo(horas2) : horas2.compareTo(horas1);

  void chamarUsuario() async {
    User? usuario = await _firebaseAuth.currentUser;
    if (usuario != null) {
      setState(() {
        nome = usuario.displayName ?? '';
        email = usuario.email ?? '';
      });
    }
  }

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
            SizedBox(height: 10),
            Center(
              child: Text(
                'Formato de Exportação',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
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
              icon: Icon(Icons.download),
              onPressed: () {},
              label: Text('CSV'),
            ),
            SizedBox(height: 5),
            ElevatedButton.icon(
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
              icon: Icon(Icons.download),
              onPressed: () {},
              label: Text('TXT'),
            ),
            SizedBox(height: 5),
            ElevatedButton.icon(
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
              icon: Icon(Icons.download),
              onPressed: () {},
              label: Text('XML'),
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
