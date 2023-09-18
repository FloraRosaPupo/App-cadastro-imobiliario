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
  late DatabaseReference _imoveisRef;

  List<Dados> imoveis = [];

  @override
  void initState() {
    super.initState();
    _imoveisRef = FirebaseDatabase.instance.reference().child('imoveis');
    chamarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDinamica(),
      drawer: menuLateralDinamico(nome, email),
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildList();
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao inicializar o Firebase'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildList() {
    return StreamBuilder<DatabaseEvent>(
      stream: _imoveisRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar imóveis: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.snapshot.value;
        imoveis.clear();

        if (data != null && data is Map<dynamic, dynamic>) {
          data.forEach((key, value) {
            imoveis.add(Dados(
              SIAT: value['Inscrição Siat'] ?? '',
              nome: value['Nome'] ?? '',
              cpf: value['CPF'] ?? '',
              // Mapeie todos os campos aqui
            ));
          });
        }

        return ListView.separated(
          itemCount: imoveis.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Rua: ${imoveis[index].rua}'),
              subtitle: Text('Nº: ${imoveis[index].numero}'),
              trailing: Text('Quarteirão: ${imoveis[index].quarteirao}'),
            );
          },
          separatorBuilder: (context, index) => Divider(),
        );
      },
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
