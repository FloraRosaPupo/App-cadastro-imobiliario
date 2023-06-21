// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/functions.dart';
import 'package:projeto_prefeitura/main.dart';
import 'package:projeto_prefeitura/pages/exportar.dart';
import 'package:projeto_prefeitura/pages/forms/contribuinte.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projeto_prefeitura/pages/forms/imovel.dart';
import 'package:projeto_prefeitura/pages/quarteiroes.dart';

class Painel extends StatefulWidget {
  const Painel({super.key});

  @override
  State<Painel> createState() => _PainelState();
}

class _PainelState extends State<Painel> {
  final _firebaseAuth = FirebaseAuth.instance;
  String nome = '';
  String email = '';

  @override
  initState() {
    chamarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDinamica(),
      drawer: menuLateralDinamico(nome, email),
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Ola ' + nome + ', qual atividade irá realizar hoje?',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
                Espacamento10(),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Quarteiroes()));
                  },
                  child: Text('Atualizar Dados do Imóvel'),
                ),
                Espacamento10(),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Search2()));
                  },
                  child: Text('Atualizar Dados do Contribuinte'),
                ),
                Espacamento10(),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Exportar()));
                  },
                  child: Text('Exportar Dados'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*Future<bool> verificarToken() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    if (sharedPreference.getString('token') != null) {
      return true;
    } else {
      return false;
    }
  }*/

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

class Search2 extends StatelessWidget {
  const Search2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDinamica(),
      //drawer: menuLateralDinamico(),
      body: Container(
        padding: EdgeInsets.only(top: 400, left: 40, right: 40),
        alignment: Alignment.center,
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            TextField(
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  labelText: "Digite o numero do CPF:",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                  ),
                  focusedBorder: FocusedBorder(),
                  enabledBorder: EnableBorder(),
                ),
                keyboardType: TextInputType.number),
            Espacamento10(),
            ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Contribuinte()));
              },
              child: Text('Acessar dados do Contribuinte'),
            ),
          ],
        ),
      ),
    );
  }
}
