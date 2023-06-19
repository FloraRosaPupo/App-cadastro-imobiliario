// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_prefeitura/main.dart';
import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/pages/homepage.dart';
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
  final _nomeController = TextEditingController(); //recebe os dados do usuario
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
                controller: _nomeController,
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
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color.fromARGB(190, 7, 62, 77),
                    )),
              ),
              Espacamento10(),
              TextField(
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
              TextField(
                controller: _passwordController,
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
                  ),
                ),
              ),
              Espacamento10(),
              ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () {
                  cadastrar();
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
    ));
  }

  void cadastrar() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (userCredential != null) {
        userCredential.user!.updateDisplayName(_nomeController.text);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Crie uma senha mais forte"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Este email ja foi cadastrado"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
