// ignore_for_file: unused_import, unused_local_variable, unnecessary_null_comparison

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:projeto_prefeitura/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/pages/painel.dart';
import 'package:projeto_prefeitura/pages/registerpage.dart';
import 'package:projeto_prefeitura/pages/exportar.dart';
import 'package:projeto_prefeitura/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(); //recebe os dados do usuario
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          child: Center(
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "assets/image/brasao.png",
                        height: 125,
                        width: 125,
                        alignment: Alignment.center,
                      ),
                      Espacamento10(),
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
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          labelText: "Email:",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                          ),
                          focusedBorder: FocusedBorder(),
                          enabledBorder: EnableBorder(),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color.fromARGB(190, 7, 62, 77),
                          ),
                        ),
                      ),
                      Espacamento10(),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.number,
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
                            prefixIcon: Icon(
                              Icons.password_sharp,
                              color: Color.fromARGB(190, 7, 62, 77),
                            )),
                      ),
                      Espacamento10(),
                      ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () {
                          login();
                        },
                        child: Text('Entrar'),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 34, 34, 34)),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                        },
                        child: Text(
                          'Possui Cadastro? Clique aqui para fazer o seu Cadastro',
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    ],
                  )))),
    );
  }

  void login() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (userCredential != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Painel()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Usuário não encontrado"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Senha incorreta, tente novamente"),
            backgroundColor: Colors.redAccent,
          ),
        );
        _passwordController.clear();
      }
    }
  }
}
