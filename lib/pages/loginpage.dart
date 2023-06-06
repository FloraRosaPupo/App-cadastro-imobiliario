import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_prefeitura/main.dart';

import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/pages/painel.dart';
import 'package:projeto_prefeitura/pages/registerpage.dart';
import 'package:projeto_prefeitura/pages/exportar.dart';
import 'package:projeto_prefeitura/functions.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDinamica(),
      drawer: menuLateralDinamico(),
      body: Container(
        padding: EdgeInsets.only(top: 300, left: 40, right: 40),
        alignment: Alignment.center,
        color: Colors.transparent,
        child: ListView(
          children: <Widget>[
            Text(
              'Faça o Login ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
            Espacamento5(),
            Text(
              'Preencha seus dados ',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 17),
            ),
            Espacamento10(),
            TextField(
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  labelText: "Número de Inscrição:",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                  ),
                  focusedBorder: FocusedBorder(),
                  enabledBorder: EnableBorder(),
                ),
                keyboardType: TextInputType.number),
            Espacamento10(),
            TextField(
              obscureText: true,
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Senha:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                focusedBorder: FocusedBorder(),
                enabledBorder: EnableBorder(),
              ),
            ),
            Espacamento10(),
            ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Painel()));
              },
              child: Text('Entrar'),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 34, 34, 34)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              child: Text(
                'Possui Cadastro? Clique aqui para fazer o seu Cadastro',
                style: TextStyle(color: Colors.black54),
              ),
            )
          ],
        ),
      ),
    );
  }
}
