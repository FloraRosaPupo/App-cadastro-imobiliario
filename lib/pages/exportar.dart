import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../functions.dart';
import 'dart:async';
import 'package:csv/csv.dart';
import 'dart:io';

class Dados {
  final String SIAT;
  final String nome;
  final String cpf;
  final String caracterizacao;
  final String celular;
  final String cobertura;
  final String contribuinte;
  final String coordenadas;
  final String data1;
  final String data2;
  final String data3;
  final String dataNascimento;
  final String fotoAerea;
  final String fotoFrontal;
  final String horario1;
  final String horario2;
  final String horario3;
  final String numero;
  final String numPavimentos;
  final String observacao;
  final String piso;
  final String quarteirao;
  final String responsavelCadastro;
  final String rua;
  //final int sequencia;
  final String situacao;
  final String visita;
  final String id;

  const Dados({
    required this.SIAT,
    required this.nome,
    required this.cpf,
    required this.caracterizacao,
    required this.celular,
    required this.cobertura,
    required this.contribuinte,
    required this.coordenadas,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.dataNascimento,
    required this.fotoAerea,
    required this.fotoFrontal,
    required this.horario1,
    required this.horario2,
    required this.horario3,
    required this.numero,
    required this.numPavimentos,
    required this.observacao,
    required this.piso,
    required this.quarteirao,
    required this.responsavelCadastro,
    required this.rua,
    //required this.sequencia,
    required this.situacao,
    required this.visita,
    required this.id,
  });

  Dados copy({
    String? SIAT,
    String? nome,
    String? cpf,
    String? caracterizacao,
    String? celular,
    String? cobertura,
    String? contribuinte,
    String? coordenadas,
    String? data1,
    String? data2,
    String? data3,
    String? dataNascimento,
    String? fotoAerea,
    String? fotoFrontal,
    String? horario1,
    String? horario2,
    String? horario3,
    String? numero,
    String? numPavimentos,
    String? observacao,
    String? piso,
    String? quarteirao,
    String? responsavelCadastro,
    String? rua,
    //int? sequencia,
    String? situacao,
    String? visita,
    String? id,
  }) =>
      Dados(
        SIAT: SIAT ?? this.SIAT,
        nome: nome ?? this.nome,
        cpf: cpf ?? this.cpf,
        caracterizacao: caracterizacao ?? this.caracterizacao,
        celular: celular ?? this.celular,
        cobertura: cobertura ?? this.cobertura,
        contribuinte: contribuinte ?? this.contribuinte,
        coordenadas: coordenadas ?? this.coordenadas,
        data1: data1 ?? this.data1,
        data2: data2 ?? this.data2,
        data3: data3 ?? this.data3,
        dataNascimento: dataNascimento ?? this.dataNascimento,
        fotoAerea: fotoAerea ?? this.fotoAerea,
        fotoFrontal: fotoFrontal ?? this.fotoFrontal,
        horario1: horario1 ?? this.horario1,
        horario2: horario2 ?? this.horario2,
        horario3: horario3 ?? this.horario3,
        numero: numero ?? this.numero,
        numPavimentos: numPavimentos ?? this.numPavimentos,
        observacao: observacao ?? this.observacao,
        piso: piso ?? this.piso,
        quarteirao: quarteirao ?? this.quarteirao,
        responsavelCadastro: responsavelCadastro ?? this.responsavelCadastro,
        rua: rua ?? this.rua,
        //sequencia: sequencia ?? this.sequencia,
        situacao: situacao ?? this.situacao,
        visita: visita ?? this.visita,
        id: id ?? this.id,
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
  List<Dados> dados = [];
  int? sortColumnIndex;
  bool isAscending = false;
  int _currentPage = 1;
  int _dataPerPage = 20; // Número de itens a serem carregados por página
  bool _isLoading = false;
  bool _loadingMore = false;
  String? _lastKey;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //chamarUsuario();
    _scrollController.addListener(_scrollListener);
    _lastKey = null; // Inicialize _lastKey como null
    buscarDadosEmTempoReal();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_loadingMore) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    if (_isLoading || _loadingMore) {
      return;
    }

    setState(() {
      _loadingMore = true; // Defina _loadingMore como true aqui
    });

    _currentPage++;

    buscarDadosEmTempoReal(); // Chame sua função de busca de dados aqui

    setState(() {
      _loadingMore =
          false; // Defina _loadingMore de volta como false quando o carregamento estiver concluído
    });
  }

  void buscarDadosEmTempoReal() {
    final databaseReference =
        FirebaseDatabase.instance.reference().child('imoveis');

    // Calcular o índice inicial dos dados a buscar com base na última chave conhecida
    Query query;
    if (_lastKey == null) {
      query = databaseReference.limitToFirst(_dataPerPage);
    } else {
      query = databaseReference
          .orderByKey()
          .startAfter([_lastKey]).limitToFirst(_dataPerPage);
    }

    print('Iniciando busca de dados em tempo real...');

    _dadosSubscription = query.onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      final data = dataSnapshot.value;

      print('DataSnapshot: $dataSnapshot');
      print('Data: $data');

      try {
        if (data != null && data is List) {
          // Verifica se os dados são uma lista
          List<Dados> dadosList = [];

          for (var i = 0; i < data.length; i++) {
            final imovel = data[i];

            if (imovel != null && imovel is Map<dynamic, dynamic>) {
              final String siat = imovel['Inscrição Siat'].toString() ?? '';
              final String nome = imovel['Nome'] ?? '';
              final String cpf = imovel['CPF'] ?? '';
              final String caracterizacao = imovel['Caracterização'] ?? '';
              final String celular = imovel['Celular'] ?? '';
              final String cobertura = imovel['Cobertura'] ?? '';
              final String contribuinte = imovel['Contribuinte'] ?? '';
              final String coordenadas = imovel['Coordenadas'] ?? '';
              final String data1 = imovel['Data 1'] ?? '';
              final String data2 = imovel['Data 2'] ?? '';
              final String data3 = imovel['Data 3'] ?? '';
              final String dataNascimento = imovel['Data de Nascimento'] ?? '';
              final String fotoAerea = imovel['Foto Aérea'] ?? '';
              final String fotoFrontal = imovel['Foto Frontal'] ?? '';
              final String horario1 = imovel['Horario 1'] ?? '';
              final String horario2 = imovel['Horario 2'] ?? '';
              final String horario3 = imovel['Horario 3'] ?? '';
              final String numero = imovel['Nº'] ?? '';
              final String numPavimentos =
                  imovel['Nº de Pavimentos'] ?? ''; // Converte para String
              final String observacao = imovel['Observação'] ?? '';
              final String piso = imovel['Piso'] ?? '';
              final String quarteirao = imovel['Quarteirão'] ?? '';
              final String responsavelCadastro =
                  imovel['Responsavel Cadastro'] ?? '';
              final String rua = imovel['Rua'] ?? '';
              //final int sequencia = imovel['Sequência'] ?? 0;
              final String situacao = imovel['Situação'] ?? '';
              final String visita = imovel['Visita'].toString() ?? '';
              final String id = i
                  .toString(); // Use i como ID (pode ser ajustado conforme necessário)

              dadosList.add(Dados(
                SIAT: siat,
                nome: nome,
                cpf: cpf,
                caracterizacao: caracterizacao,
                celular: celular,
                cobertura: cobertura,
                contribuinte: contribuinte,
                coordenadas: coordenadas,
                data1: data1,
                data2: data2,
                data3: data3,
                dataNascimento: dataNascimento,
                fotoAerea: fotoAerea,
                fotoFrontal: fotoFrontal,
                horario1: horario1,
                horario2: horario2,
                horario3: horario3,
                numero: numero,
                numPavimentos: numPavimentos,
                observacao: observacao,
                piso: piso,
                quarteirao: quarteirao,
                responsavelCadastro: responsavelCadastro,
                rua: rua,
                // sequencia: sequencia,
                situacao: situacao,
                visita: visita,
                id: id,
              ));

              // Atualize a última chave usada
              _lastKey = dataSnapshot.key;
            }
          }

          setState(() {
            if (_currentPage == 1) {
              dados = dadosList;
            } else {
              dados.addAll(dadosList);
            }
          });

          print('Dados buscados com sucesso: $dadosList');
        } else {
          setState(() {
            dados = [];
          });
          print(
              'Erro ao buscar dados: Dados inválidos ou permissão insuficiente.');
        }
      } catch (e) {
        setState(() {
          dados = [];
        });
        print('Erro ao buscar dados: $e');
      }
    }, onError: (error) {
      setState(() {
        dados = [];
      });
      print('Erro ao buscar dados: $error');
    });
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
        ),
      );

  Widget buildDataTable() {
    final columns = [
      'SIAT',
      'Nome',
      'CPF',
      'Caracterização',
      'Celular',
      'Cobertura',
      'Contribuinte',
      'Coordenadas',
      'Data 1',
      'Data 2',
      'Data 3',
      'Data de Nascimento',
      'Foto Aérea',
      'Foto Frontal',
      'Horario 1',
      'Horario 2',
      'Horario 3',
      'Nº',
      'Nº de Pavimentos',
      'Observação',
      'Piso',
      'Quarteirão',
      'Responsavel Cadastro',
      'Rua',
      //'Sequência',
      'Situação',
      'Visita',
      'id',
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
            label: Container(
              width: 300.0, // Defina a largura fixa para todas as colunas
              child: Text(column),
            ),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows() => dados.map((Dados dados) {
        final cells = [
          dados.SIAT,
          dados.nome,
          dados.cpf,
          dados.caracterizacao,
          dados.celular,
          dados.cobertura,
          dados.contribuinte,
          dados.coordenadas,
          dados.data1,
          dados.data2,
          dados.data3,
          dados.dataNascimento,
          dados.fotoAerea,
          dados.fotoFrontal,
          dados.horario1,
          dados.horario2,
          dados.horario3,
          dados.numero,
          dados.numPavimentos,
          dados.observacao,
          dados.piso,
          dados.quarteirao,
          dados.responsavelCadastro,
          dados.rua,
          //  dados.sequencia,
          dados.situacao,
          dados.visita,
          dados.id,
        ];
        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map((data) => DataCell(
            Container(
              width: 200.0, // Mesma largura que definida nas colunas
              child: Text('$data'),
            ),
          ))
      .toList();

  void onSort(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        dados.sort((dados1, dados2) =>
            compareString_siat(ascending, dados1.SIAT, dados2.SIAT));
        break;
      case 1:
        dados.sort((dados1, dados2) =>
            compareString_nome(ascending, dados1.nome, dados2.nome));
        break;
      case 2:
        dados.sort((dados1, dados2) =>
            compareString_cpf(ascending, dados1.cpf, dados2.cpf));
        break;
      case 3:
        dados.sort((dados1, dados2) => compareString_caracterizacao(
            ascending, dados1.caracterizacao, dados2.caracterizacao));
        break;
      case 4:
        dados.sort((dados1, dados2) =>
            compareString_celular(ascending, dados1.celular, dados2.celular));
        break;
      case 5:
        dados.sort((dados1, dados2) => compareString_cobertura(
            ascending, dados1.cobertura, dados2.cobertura));
        break;
      case 6:
        dados.sort((dados1, dados2) => compareString_contribuinte(
            ascending, dados1.contribuinte, dados2.contribuinte));
        break;
      case 7:
        dados.sort((dados1, dados2) => compareString_coordenadas(
            ascending, dados1.coordenadas, dados2.coordenadas));
        break;
      case 8:
        dados.sort((dados1, dados2) =>
            compareString_data(ascending, dados1.data1, dados2.data1));
        break;
      case 9:
        dados.sort((dados1, dados2) =>
            compareString_data(ascending, dados1.data2, dados2.data2));
        break;
      case 10:
        dados.sort((dados1, dados2) =>
            compareString_data(ascending, dados1.data3, dados2.data3));
        break;
      case 11:
        dados.sort((dados1, dados2) => compareString_data(
            ascending, dados1.dataNascimento, dados2.dataNascimento));
        break;
      case 12:
        dados.sort((dados1, dados2) =>
            compareString_data(ascending, dados1.fotoAerea, dados2.fotoAerea));
        break;
      case 13:
        dados.sort((dados1, dados2) => compareString_data(
            ascending, dados1.fotoFrontal, dados2.fotoFrontal));
        break;
      case 14:
        dados.sort((dados1, dados2) =>
            compareString_horario(ascending, dados1.horario1, dados2.horario1));
        break;
      case 15:
        dados.sort((dados1, dados2) =>
            compareString_horario(ascending, dados1.horario2, dados2.horario2));
        break;
      case 16:
        dados.sort((dados1, dados2) =>
            compareString_horario(ascending, dados1.horario3, dados2.horario3));
        break;
      case 17:
        dados.sort((dados1, dados2) =>
            compareString_num(ascending, dados1.numero, dados2.numero));
        break;
      case 18:
        dados.sort((dados1, dados2) => compareString_numPavimentos(
            ascending, dados1.numPavimentos, dados2.numPavimentos));
        break;
      case 19:
        dados.sort((dados1, dados2) => compareString_observacao(
            ascending, dados1.observacao, dados2.observacao));
        break;
      case 20:
        dados.sort((dados1, dados2) =>
            compareString_piso(ascending, dados1.piso, dados2.piso));
        break;
      case 21:
        dados.sort((dados1, dados2) => compareString_quart(
            ascending, dados1.quarteirao, dados2.quarteirao));
        break;
      case 22:
        dados.sort((dados1, dados2) => compareString_responsavelCadastro(
            ascending, dados1.responsavelCadastro, dados2.responsavelCadastro));
        break;
      case 23:
        dados.sort((dados1, dados2) =>
            compareString_rua(ascending, dados1.rua, dados2.rua));
        break;
      case 24:
      /*dados.sort((dados1, dados2) => compareInt_sequencia(
            ascending, dados1.sequencia, dados2.sequencia));
        break;*/
      case 25:
        dados.sort((dados1, dados2) => compareString_situacao(
            ascending, dados1.situacao, dados2.situacao));
        break;
      case 26:
        dados.sort((dados1, dados2) =>
            compareString_visita(ascending, dados1.visita, dados2.visita));
        break;
      case 27:
        dados.sort((dados1, dados2) =>
            compareString_id(ascending, dados1.id, dados2.id));
        break;
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString_nome(bool ascending, String nome1, String nome2) =>
      ascending ? nome1.compareTo(nome2) : nome2.compareTo(nome1);

  int compareString_siat(bool ascending, String siat1, String siat2) =>
      ascending ? siat1.compareTo(siat2) : siat2.compareTo(siat1);

  int compareString_cpf(bool ascending, String cpf1, String cpf2) =>
      ascending ? cpf1.compareTo(cpf2) : cpf2.compareTo(cpf1);

  int compareString_caracterizacao(
          bool ascending, String carac1, String carac2) =>
      ascending ? carac1.compareTo(carac2) : carac2.compareTo(carac1);

  int compareString_celular(bool ascending, String cel1, String cel2) =>
      ascending ? cel1.compareTo(cel2) : cel2.compareTo(cel1);

  int compareString_cobertura(bool ascending, String cob1, String cob2) =>
      ascending ? cob1.compareTo(cob2) : cob2.compareTo(cob1);

  int compareString_contribuinte(
          bool ascending, String contr1, String contr2) =>
      ascending ? contr1.compareTo(contr2) : contr2.compareTo(contr1);

  int compareString_coordenadas(bool ascending, String coord1, String coord2) =>
      ascending ? coord1.compareTo(coord2) : coord2.compareTo(coord1);

  int compareString_data(bool ascending, String data1, String data2) =>
      ascending ? data1.compareTo(data2) : data2.compareTo(data1);

  int compareString_horario(bool ascending, String horas1, String horas2) =>
      ascending ? horas1.compareTo(horas2) : horas2.compareTo(horas1);

  int compareString_num(bool ascending, String num1, String num2) =>
      ascending ? num1.compareTo(num2) : num2.compareTo(num1);

  int compareString_numPavimentos(bool ascending, String pav1, String pav2) =>
      ascending ? pav1.compareTo(pav2) : pav2.compareTo(pav1);

  int compareString_observacao(bool ascending, String obs1, String obs2) =>
      ascending ? obs1.compareTo(obs2) : obs2.compareTo(obs1);

  int compareString_piso(bool ascending, String piso1, String piso2) =>
      ascending ? piso1.compareTo(piso2) : piso2.compareTo(piso1);

  int compareString_quart(bool ascending, String quart1, String quart2) =>
      ascending ? quart1.compareTo(quart2) : quart2.compareTo(quart1);

  int compareString_responsavelCadastro(
          bool ascending, String resp1, String resp2) =>
      ascending ? resp1.compareTo(resp2) : resp2.compareTo(resp1);

  int compareString_rua(bool ascending, String rua1, String rua2) =>
      ascending ? rua1.compareTo(rua2) : rua2.compareTo(rua1);

  /*int compareInt_sequencia(bool ascending, int seq1, int seq2) =>
      ascending ? seq1.compareTo(seq2) : seq2.compareTo(seq1);*/

  int compareString_situacao(bool ascending, String sit1, String sit2) =>
      ascending ? sit1.compareTo(sit2) : sit2.compareTo(sit1);

  int compareString_visita(bool ascending, String vis1, String vis2) =>
      ascending ? vis1.compareTo(vis2) : vis2.compareTo(vis1);

  int compareString_id(bool ascending, String id1, String id2) =>
      ascending ? id1.compareTo(id2) : id2.compareTo(id1);

  void chamarUsuario() {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      nome = user.displayName ?? '';
      email = user.email ?? '';
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    style: raisedButtonStyle,
                    icon: Icon(Icons.download),
                    onPressed: () => exportarCSV(dados, context),
                    label: Text('CSV'),
                  ),
                  SizedBox(width: 5),
                  ElevatedButton.icon(
                    style: raisedButtonStyle,
                    icon: Icon(Icons.download),
                    onPressed: () => exportarTXT(dados, context),
                    label: Text('TXT'),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

void exportarCSV(List<Dados> dados, BuildContext context) async {
  List<List<dynamic>> csvData = [];

  for (var dado in dados) {
    csvData.add([
      dado.SIAT,
      dado.nome,
      dado.cpf,
      dado.caracterizacao,
      dado.celular,
      dado.cobertura,
      dado.contribuinte,
      dado.coordenadas,
      dado.data1,
      dado.data2,
      dado.data3,
      dado.dataNascimento,
      dado.fotoAerea,
      dado.fotoFrontal,
      dado.horario1,
      dado.horario2,
      dado.horario3,
      dado.numero,
      dado.numPavimentos,
      dado.observacao,
      dado.piso,
      dado.quarteirao,
      dado.responsavelCadastro,
      dado.rua,
      dado.situacao,
      dado.visita,
      dado.id,
    ]);
  }

  String csv = const ListToCsvConverter().convert(csvData);

  final downloadsDirectory = Directory('/storage/emulated/0/Download');

  if (await downloadsDirectory.exists()) {
    final file = File('${downloadsDirectory.path}/dados_exportados.csv');
    await file.writeAsString(csv);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Arquivo CSV exportado para a pasta de Download'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Erro ao exportar arquivo CSV: Pasta de Download não encontrada'),
      ),
    );
  }
}

void exportarTXT(List<Dados> dados, BuildContext context) async {
  String txtData =
      ''; // Inicializa uma string vazia para armazenar os dados de texto

  // Percorre a lista 'dados' e adiciona cada registro à string 'txtData'
  for (var dadosItem in dados) {
    txtData += 'SIAT: ${dadosItem.SIAT}\n';
    txtData += 'Nome: ${dadosItem.nome}\n';
    txtData += 'CPF: ${dadosItem.cpf}\n';
    txtData += 'Caracterização: ${dadosItem.caracterizacao}\n';
    txtData += 'Celular: ${dadosItem.celular}\n';
    txtData += 'Cobertura: ${dadosItem.cobertura}\n';
    txtData += 'Contribuinte: ${dadosItem.contribuinte}\n';
    txtData += 'Coordenadas: ${dadosItem.coordenadas}\n';
    txtData += 'Data 1: ${dadosItem.data1}\n';
    txtData += 'Data 2: ${dadosItem.data2}\n';
    txtData += 'Data 3: ${dadosItem.data3}\n';
    txtData += 'Data de Nascimento: ${dadosItem.dataNascimento}\n';
    txtData += 'Foto Aérea: ${dadosItem.fotoAerea}\n';
    txtData += 'Foto Frontal: ${dadosItem.fotoFrontal}\n';
    txtData += 'Horario 1: ${dadosItem.horario1}\n';
    txtData += 'Horario 2: ${dadosItem.horario2}\n';
    txtData += 'Horario 3: ${dadosItem.horario3}\n';
    txtData += 'Nº: ${dadosItem.numero}\n';
    txtData += 'Nº de Pavimentos: ${dadosItem.numPavimentos}\n';
    txtData += 'Observação: ${dadosItem.observacao}\n';
    txtData += 'Piso: ${dadosItem.piso}\n';
    txtData += 'Quarteirão: ${dadosItem.quarteirao}\n';
    txtData += 'Responsavel Cadastro: ${dadosItem.responsavelCadastro}\n';
    txtData += 'Rua: ${dadosItem.rua}\n';
    txtData += 'Situação: ${dadosItem.situacao}\n';
    txtData += 'Visita: ${dadosItem.visita}\n';
    txtData += 'ID: ${dadosItem.id}\n';
    txtData +=
        '--------------------------------------------------\n'; // Adiciona um separador entre os registros
  }

  final downloadsDirectory = Directory('/storage/emulated/0/Download');

  if (await downloadsDirectory.exists()) {
    final file = File('${downloadsDirectory.path}/dados_exportados.txt');
    await file.writeAsString(txtData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Arquivo TXT exportado para a pasta de Download'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Erro ao exportar arquivo TXT: Pasta de Download não encontrada'),
      ),
    );
  }
}
