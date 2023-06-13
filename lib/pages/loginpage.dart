import 'dart:convert';

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
  final _formkey = GlobalKey<FormState>(); //verificacao de erro
  final _inscricaoController =
      TextEditingController(); //recebe os dados do usuario
  final _passwordController = TextEditingController();

  //recebe os dados do usuario

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formkey,
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
                        controller: _inscricaoController,
                        keyboardType: TextInputType.number,

                        //validar email
                        validator: (inscricao) {
                          if (inscricao == null || inscricao.isEmpty) {
                            return 'Por favor, digite sua inscrição na prefeitura';
                          } else if (inscricao == TextInputType.number) {
                            return 'Por favor, digite os numeros da inscrição na prefeitura';
                          }
                          return null;
                        },
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
                      ),
                      Espacamento10(),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (senha) {
                          if (senha == null || senha.isEmpty) {
                            return 'Por favor, digite sua senha';
                          } else if (senha.length < 6) {
                            return 'Por favor, digite uma senha maior';
                          }
                          return null;
                        },
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
                        onPressed: () async {
                          //verifica o estado do teclado
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          //verificando se os campos do forms foram preenchidos
                          if (_formkey.currentState!.validate()) {
                            bool logou = await login();

                            //fecho o teclado
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }

                            if (logou) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Painel()));
                            } else {
                              _passwordController.clear();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
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

  final snackBar = SnackBar(
    content: Text(
      'Inscrição ou Senha são inválidos',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.redAccent,
  );

  Future<bool> login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse('http://127.0.0.1:54601/login');
    var resposta = await http.post(
      url,
      body: {
        'username': _inscricaoController.text,
        'password': _passwordController.text
      },
    );

    if (resposta.statusCode == 200) {
      print(jsonDecode(resposta.body)['token']);
      if (resposta.body.isNotEmpty) {
        json.decode(resposta.body);
      }
      return true;
    } else {
      print(jsonDecode(resposta.body));
      return false;
    }
  }
}
