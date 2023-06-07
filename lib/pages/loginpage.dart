import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:projeto_prefeitura/main.dart';

import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/pages/painel.dart';
import 'package:projeto_prefeitura/pages/registerpage.dart';
import 'package:projeto_prefeitura/pages/exportar.dart';
import 'package:projeto_prefeitura/functions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>(); //verificacao de erro
  final _inscricaoController =
      TextEditingController(); //recebe os dados do usuario
  final _passwordController =
      TextEditingController(); //recebe os dados do usuario

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
                        height: 135,
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
                        onPressed: () {},
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
}
