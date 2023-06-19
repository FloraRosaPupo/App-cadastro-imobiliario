// ignore_for_file: unused_import

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_prefeitura/main.dart';
import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/pages/loginpage.dart';
import 'package:projeto_prefeitura/pages/painel.dart';
import 'package:projeto_prefeitura/pages/exportar.dart';
import 'package:projeto_prefeitura/functions.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset(
                  "assets/image/brasao.png",
                  height: 125,
                  width: 125,
                  alignment: Alignment.center,
                ),
                Espacamento10(),
                Text(
                  'Crie sua conta ',
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Painel()));
                  },
                  child: Text('Cadastrar'),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 34, 34, 34)),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    'Ja possui Cadastro? Clique aqui para acessar a tela de Login',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
