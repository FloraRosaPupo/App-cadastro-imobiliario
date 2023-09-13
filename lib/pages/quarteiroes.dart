import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/functions.dart';
import '../dados.dart';
import 'dart:async';

class Quarteiroes extends StatefulWidget {
  @override
  _QuarteiroesState createState() => _QuarteiroesState();
}

class _QuarteiroesState extends State<Quarteiroes> {
  final _firebaseAuth = FirebaseAuth.instance;
  String nome = '';
  String email = '';
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  late DatabaseReference _imoveisRef;

  List<Dados> imoveis = []; // Agora a lista contém objetos da classe Dados
  StreamSubscription<DatabaseEvent>?
      _dadosSubscription; // Correção: Defina _dadosSubscription aqui

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    _imoveisRef = FirebaseDatabase.instance.reference().child('imoveis');
    _carregarImoveis();
  }

  void _carregarImoveis() {
    _imoveisRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        print("Conteúdo do Snapshot: ${event.snapshot.value}");
        final dynamic data = event.snapshot.value;
        if (data is Map<dynamic, dynamic>) {
          imoveis.clear();
          data.forEach((key, value) {
            imoveis.add(Dados(
              SIAT: value['Inscrição Siat'],
              nome: value['Nome'],
              cpf: value['CPF'],
              caracterizacao: value['Caracterização'],
              celular: value['Celular'],
              cobertura: value['Cobertura'],
              contribuinte: value['Contribuinte'],
              coordenadas: value['Coordenadas'],
              data1: value['Data 1'],
              data2: value['Data 2'],
              data3: value['Data 3'],
              dataNascimento: value['Data de Nascimento'],
              fotoAerea: value['Foto Aérea'],
              fotoFrontal: value['Foto Frontal'],
              horario1: value['Horario 1'],
              horario2: value['Horario 2'],
              horario3: value['Horario 3'],
              numero: value['Nº'],
              numPavimentos: value['Nº de Pavimentos'],
              observacao: value['Observação'],
              piso: value['Piso'],
              quarteirao: value['Quarteirão'],
              responsavelCadastro: value['Responsavel Cadastro'],
              rua: value['Rua'],
              situacao: value['Situação'],
              visita: value['Visita'],
              id: value['id'],
            ));
          });
          setState(() {});
        }
      }
    }).catchError((error) {
      print("Erro ao carregar imóveis: $error");
    });
  }

  @override
  void dispose() {
    // Certifique-se de cancelar a inscrição ao sair da tela.
    _dadosSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDinamica(),
      drawer: menuLateralDinamico(nome, email),
      body: ListView.builder(
        itemCount: imoveis.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                'Rua: ${imoveis[index].rua}'), // Acesse as propriedades diretamente do objeto Dados
            subtitle: Text('Nº: ${imoveis[index].numero}'),
            trailing: Text('Quarteirão: ${imoveis[index].quarteirao}'),
            // Você pode adicionar mais informações aqui conforme necessário.
          );
        },
      ),
    );
  }

  void chamarUsuario() {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      nome = user.displayName ?? '';
      email = user.email ?? '';
    }
  }
}
