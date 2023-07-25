// ignore_for_file: unused_import, duplicate_import

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/pages/galeria.dart';
import 'package:projeto_prefeitura/pages/loginpage.dart';
import 'package:projeto_prefeitura/pages/painel.dart';
import 'package:projeto_prefeitura/pages/quarteiroes.dart';
import 'package:projeto_prefeitura/pages/registerpage.dart';
import 'package:projeto_prefeitura/pages/exportar.dart';
import 'package:projeto_prefeitura/pages/forms/contribuinte.dart';
import 'package:projeto_prefeitura/pages/forms/imovel.dart';
import 'package:projeto_prefeitura/pages/painel.dart';

import 'package:flutter/src/material/icon_button.dart';

List<String> list_cobertura = <String>[
  ' Selecione a cobertura ',
  ' Palha/Zinco ',
  ' Cimento ',
  ' Telha Barro ',
  ' Laje ',
  ' Especial '
];

List<String> list_piso = <String>[
  ' Selecione o piso ',
  ' Terra Batida ',
  ' Cimento ',
  ' Cerâmica/Mosaico ',
  ' Madeira ',
  ' Material Plástico ',
  ' Tacos ',
  ' Especial '
];

class DropdownCobertura extends StatefulWidget {
  const DropdownCobertura({super.key});

  @override
  State<DropdownCobertura> createState() => _DropdownCoberturaState();
}

class _DropdownCoberturaState extends State<DropdownCobertura> {
  String dropdownValue = list_cobertura.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(
        Icons.arrow_drop_down_outlined,
        size: 25,
      ),
      elevation: 5,
      style: const TextStyle(
        color: Colors.black,
      ),
      underline: Container(
        height: 300,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list_cobertura.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
            ),
          ),
        );
      }).toList(),
      hint: const Text('Selecione a Cobertura'),
    );
  }
}

class DropdownPiso extends StatefulWidget {
  const DropdownPiso({super.key});

  @override
  State<DropdownPiso> createState() => _DropdownPisoState();
}

class _DropdownPisoState extends State<DropdownPiso> {
  String dropdownValue = list_piso.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(
        Icons.arrow_drop_down_outlined,
        size: 25,
      ),
      elevation: 5,
      style: const TextStyle(
        color: Colors.black,
      ),
      underline: Container(
        height: 300,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list_piso.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
            ),
          ),
        );
      }).toList(),
      hint: const Text('Selecione o Piso'),
    );
  }
}

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Color.fromARGB(221, 255, 255, 255),
  primary: Color.fromARGB(191, 18, 108, 133),
  minimumSize: Size(100, 50),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
  textStyle: TextStyle(fontSize: 20),
);

appBarDinamica() {
  //TabController _tabController = TabController(length: 3, vsync: this);

  return AppBar(
    toolbarHeight: 150,
    centerTitle: true,
    backgroundColor: Colors.white,
    title: Image.asset(
      "assets/image/logo.png",
      height: 100,
      alignment: Alignment.center,
    ),
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(
            Icons.menu,
            color: Color.fromARGB(190, 7, 62, 77),
            size: 35, // Changing Drawer Icon Size
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      },
    ),
    actions: [
      Builder(builder: (BuildContext context) {
        return IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Painel()));
            },
            icon: Icon(Icons.home,
                color: Color.fromARGB(190, 7, 62, 77), size: 30));
      })
    ],
  );
}

menuLateralDinamico(nome, email) {
  final _firebaseAuth = FirebaseAuth.instance;

  return Drawer(
    backgroundColor: Color.fromARGB(190, 7, 62, 77),
    child: Column(children: [
      //como deixar o nome e email global na aplicação sem precisar receber apenas do painel
      UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Color.fromARGB(188, 0, 29, 37)),
          accountName: Text(nome),
          accountEmail: Text(email)),

      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2.0, color: Colors.white12),
          ),
        ),
        padding: EdgeInsets.only(left: 7),
        child: Column(
          children: [
            Builder(builder: (BuildContext context) {
              return ListTile(
                leading: Icon(
                  Icons.home,
                  color: Color.fromARGB(255, 187, 187, 187),
                ),
                title: Text(
                  'Acessar Painel',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 187, 187, 187),
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Painel()));
                },
              );
            }),
            Builder(builder: (BuildContext context) {
              return ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Color.fromARGB(255, 187, 187, 187),
                ),
                title: Text(
                  'Encerrar seção',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 187, 187, 187),
                      fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  print('Usuário se desconectou');
                  await _firebaseAuth
                      .signOut()
                      .then((user) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          )));
                },
              );
            }),
          ],
        ),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2.0, color: Colors.white12),
          ),
        ),
        padding: EdgeInsets.only(left: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text('Atualizar Dados:',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white54,
                )),
            Espacamento5(),
            Builder(builder: (BuildContext context) {
              return ListTile(
                leading: Icon(
                  Icons.home_work,
                  color: Colors.white,
                ),
                title: Text(
                  'Imóvel',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Quarteiroes()));
                },
              );
            }),
            Builder(builder: (BuildContext context) {
              return ListTile(
                leading: Icon(
                  Icons.person_pin_circle_sharp,
                  color: Colors.white,
                ),
                title: Text(
                  'Contribuinte',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Search2()));
                },
              );
            }),
          ],
        ),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border(
              //bottom: BorderSide(width: 2.0, color: Colors.white12),
              ),
        ),
        padding: EdgeInsets.only(left: 7),
        child: Column(
          children: [
            Espacamento10(),
            Builder(builder: (BuildContext context) {
              return ListTile(
                  leading: Icon(
                    Icons.art_track,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Quarteirões',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Galeria()));
                  });
            }),
          ],
        ),
      ),

      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2.0, color: Colors.white12),
          ),
        ),
        padding: EdgeInsets.only(left: 7),
        child: Column(
          children: [
            Espacamento10(),
            Builder(builder: (BuildContext context) {
              return ListTile(
                  leading: Icon(
                    Icons.import_export,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Exportar dados',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ExportarPage()));
                  });
            }),
          ],
        ),
      )
    ]),
  );
}

//TextField
FocusedBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      borderSide: BorderSide(
        color: Color.fromARGB(190, 7, 62, 77),
      ));
}

//TextField
EnableBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      borderSide: BorderSide(
        color: Colors.black38,
      ));
}

Espacamento10() {
  return SizedBox(
    height: 10,
  );
}

Espacamento5() {
  return SizedBox(
    height: 5,
  );
}
