import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

class Galeria extends StatefulWidget {
  const Galeria({Key? key}) : super(key: key);

  @override
  State<Galeria> createState() => _GaleriaState();
}

class _GaleriaState extends State<Galeria> {
  final _firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  String nome = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    chamarUsuario();
  }

  chamarUsuario() async {
    User? usuario = await _firebaseAuth.currentUser;
    if (usuario != null) {
      print(usuario);
      setState(() {
        nome = usuario.displayName!;
        email = usuario.email!;
      });
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getGridView() async {
    return firestore.collection("gridData").get();
  }

  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      getGridView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDinamica(),
      drawer: menuLateralDinamico(nome, email),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: getGridView(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return RefreshIndicator(
              onRefresh: getRefresh,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  var ourData = snapshot.data!.docs[index];

                  return Card(
                    elevation: 10.0,  
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        ourData.data()['img'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.docs.length,
              ),
            );
          }
        },
      ),
    );
  }
}
