import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Quarteiroes extends StatefulWidget {
  @override
  _QuarteiroesState createState() => _QuarteiroesState();
}

class _QuarteiroesState extends State<Quarteiroes> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final DatabaseReference _imoveisRef =
      FirebaseDatabase.instance.reference().child('imoveis');

  List<Map<String, dynamic>> imoveis = [];

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    _carregarImoveis();
  }

  void _carregarImoveis() {
    _imoveisRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          imoveis.add(value);
        });
        setState(() {});
      }
    }).catchError((error) {
      print("Erro ao carregar imóveis: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Imóveis Firebase'),
      ),
      body: ListView.builder(
        itemCount: imoveis.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Rua: ${imoveis[index]['Rua']}'),
            subtitle: Text('Nº: ${imoveis[index]['Nº']}'),
            trailing: Text('Quarteirão: ${imoveis[index]['Quarteirão']}'),
            // Você pode adicionar mais informações aqui conforme necessário.
          );
        },
      ),
    );
  }
}
