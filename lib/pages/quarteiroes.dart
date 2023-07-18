import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_prefeitura/functions.dart';
import 'package:projeto_prefeitura/pages/forms/imovel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class Quarteiroes extends StatefulWidget {
  const Quarteiroes({Key? key}) : super(key: key);

  @override
  State<Quarteiroes> createState() => _QuarteiroesState();
}

class _QuarteiroesState extends State<Quarteiroes> {
  //chamando realtime
  FirebaseDatabase database = FirebaseDatabase.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  String nome = '';
  String email = '';
  int? minQuartosSelecionados;
  int? maxQuartosSelecionados;

  @override
  void initState() {
    super.initState();
    chamarUsuario();
  }

  void chamarUsuario() async {
    User? usuario = await _firebaseAuth.currentUser;
    if (usuario != null) {
      print(usuario);
      setState(() {
        nome = usuario.displayName!;
        email = usuario.email!;
      });
    }
  }

  Future<int> calcularQuarteiroes() async {
    DatabaseReference ref = FirebaseDatabase.instance.reference();

    int totalQuarteiroes = 0;

    ref.child('imoveis').onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data =
            Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);

        totalQuarteiroes = 0;

        data.forEach((key, value) {
          if (value['2'] != null && value['2'] is num) {
            totalQuarteiroes += (value['2'] as num).toInt();
          }
        });
      } else {
        totalQuarteiroes = 0;
      }
    });

    return totalQuarteiroes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDinamica(),
      drawer: menuLateralDinamico(nome, email),
      body: Container(
        padding: EdgeInsets.only(top: 5),
        child: ListView(
          children: [
            Espacamento10(),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Color.fromARGB(221, 255, 255, 255),
                    primary: Color.fromARGB(191, 18, 108, 133),
                    minimumSize: Size(100, 45),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          title: Text(
                            'Filtrar por número de Quarteirões',
                            style: TextStyle(fontSize: 20),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Mínimo:',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    minQuartosSelecionados =
                                        int.tryParse(value);
                                  });
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Máximo:',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    maxQuartosSelecionados =
                                        int.tryParse(value);
                                  });
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancelar',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            ElevatedButton(
                              style: raisedButtonStyle,
                              onPressed: () {
                                Navigator.pop(context);
                                // Executar a filtragem aqui
                              },
                              child: Text('Filtrar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.filter_list),
                  label: Text('Filtrar'),
                ),
                SizedBox(width: 10),
                if (minQuartosSelecionados != null ||
                    maxQuartosSelecionados != null)
                  Text(
                    '${minQuartosSelecionados ?? 'Mínimo'} - ${maxQuartosSelecionados ?? 'Máximo'}',
                    style: TextStyle(fontSize: 18),
                  ),
                if (minQuartosSelecionados != null ||
                    maxQuartosSelecionados != null)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        minQuartosSelecionados = null;
                        maxQuartosSelecionados = null;
                      });
                    },
                    icon: Icon(Icons.clear),
                  ),
              ],
            ),
            Espacamento10(),
            Container(
              padding: EdgeInsets.only(top: 1, bottom: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '1',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2.0, color: Colors.black12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Image.network(
                          'https://empreenderdinheiro.com.br/wp-content/uploads/2019/06/comprar-terreno-2-1024x683.jpg.webp',
                          height: 100,
                          width: 100,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rua Joaquim Lopes',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '123',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Fulano da Silva',
                          style: TextStyle(fontSize: 20),
                        ),
                        FutureBuilder<int>(
                          future: calcularQuarteiroes(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                'Quantidade de Quarteirões: ${snapshot.data}',
                                style: TextStyle(fontSize: 18),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Erro ao calcular quarteirões');
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Imovel(),
                            ));
                          },
                          icon: Icon(Icons.edit_square),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
