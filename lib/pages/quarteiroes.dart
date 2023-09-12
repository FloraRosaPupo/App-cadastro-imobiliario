import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../dados.dart';
import 'dart:async';

class Quarteiroes extends StatefulWidget {
  @override
  _QuarteiroesState createState() => _QuarteiroesState();
}

class _QuarteiroesState extends State<Quarteiroes> {
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

  void _carregarImoveis(){
    _imoveisRef.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null) {
        Map<dynamic, dynamic> values = event.snapshot.value;

        values.forEach((key, value) {
          // Converte os dados do Firebase em objetos da classe Dados e os adiciona à lista de imóveis.
          imoveis.add(Dados(
            SIAT: value['SIAT'],
            nome: value['nome'],
            cpf: value['cpf'],
            caracterizacao: value['caracterizacao'],
            celular: value['celular'],
            cobertura: value['cobertura'],
            contribuinte: value['contribuinte'],
            coordenadas: value['coordenadas'],
            data1: value['data1'],
            data2: value['data2'],
            data3: value['data3'],
            dataNascimento: value['dataNascimento'],
            fotoAerea: value['fotoAerea'],
            fotoFrontal: value['fotoFrontal'],
            horario1: value['horario1'],
            horario2: value['horario2'],
            horario3: value['horario3'],
            numero: value['numero'],
            numPavimentos: value['numPavimentos'],
            observacao: value['observacao'],
            piso: value['piso'],
            quarteirao: value['quarteirao'],
            responsavelCadastro: value['responsavelCadastro'],
            rua: value['rua'],
            situacao: value['situacao'],
            visita: value['visita'],
            id: value['id'],
          ));
        });
        setState(() {});
      }
    }, onError: (error) {
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
      appBar: AppBar(
        title: Text('Lista de Imóveis Firebase'),
      ),
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
}
