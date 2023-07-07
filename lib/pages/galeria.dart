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
    return firestore
        .collection("gridData")
        .orderBy('title', descending: false)
        .get();
  }

  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      getGridView();
    });
  }

  void showImageDialog(String imageUrl, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Espacamento10(),
              InteractiveViewer(
                  clipBehavior: Clip.none,
                  panEnabled: false,
                  minScale: 1,
                  maxScale: 4,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(imageUrl),
                    ),
                  )),
              Espacamento10(),
              /*Text(
                'Quarteirão ' + title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Espacamento10(),
              ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Fechar'),
              ),*/
              Espacamento10(),
            ],
          ),
        );
      },
    );
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
                  crossAxisCount: 5,
                ),
                itemBuilder: (context, index) {
                  var ourData = snapshot.data!.docs[index];

                  return GestureDetector(
                    onTap: () {
                      String imageUrl = ourData.data()['img'];
                      String title = ourData.data()['title'].toString();
                      showImageDialog(imageUrl, title);
                    },
                    child: Card(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                ourData.data()['img'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            ourData.data()['title'].toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
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
