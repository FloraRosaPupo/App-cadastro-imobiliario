// ignore_for_file: unused_import

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_prefeitura/main.dart';

import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/pages/painel.dart';
import 'package:projeto_prefeitura/pages/registerpage.dart';
import 'package:projeto_prefeitura/functions.dart';

//import 'package:intl/date_symbol_data_local.dart';
//import 'package:intl/intl.dart';

class Contribuinte extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDinamica(),
      drawer: menuLateralDinamico(),
      body: Container(
        padding: EdgeInsets.only(top: 50, left: 40, right: 40),
        alignment: Alignment.center,
        color: Colors.transparent,
        child: ListView(
          children: <Widget>[
            Text(
              'Dados pessoais do Contribuinte',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
            Espacamento5(),
            Text(
              'Preencha os dados ',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 17),
            ),
            SizedBox(
              height: 10, //colocando espaçamento
            ),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Nome:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                focusedBorder: FocusedBorder(),
                enabledBorder: EnableBorder(),
              ),
            ),
            Espacamento10(),
            TextField(
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  labelText: "CPF/CNPJ:",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                  ),
                  focusedBorder: FocusedBorder(),
                  enabledBorder: EnableBorder(),
                ),
                keyboardType: TextInputType.number),
            Espacamento10(),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Data de Nascimento:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                focusedBorder: FocusedBorder(),
                enabledBorder: EnableBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            Espacamento10(),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Telefone:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                focusedBorder: FocusedBorder(),
                enabledBorder: EnableBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            Text(
              'Endereço de Correspondência',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
            Espacamento10(),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Rua:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                focusedBorder: FocusedBorder(),
                enabledBorder: EnableBorder(),
              ),
            ),
            Espacamento10(),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Número:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                focusedBorder: FocusedBorder(),
                enabledBorder: EnableBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            Espacamento10(),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Complemento:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                focusedBorder: FocusedBorder(),
                enabledBorder: EnableBorder(),
              ),
            ),
            SizedBox(
              height: 20, //colocando espaçamento
            ),
            ElevatedButton.icon(
              style: raisedButtonStyle,
              onPressed: () {},
              label: Text('Atualizar'),
              icon: Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }
}
