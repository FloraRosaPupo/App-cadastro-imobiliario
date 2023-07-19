import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/functions.dart';

class Realtime extends StatelessWidget {
  Realtime({super.key});

  final ref = FirebaseDatabase.instance.ref('imoveis');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDinamica(),
      //drawer: menuLateralDinamico(nome, email),
      body: Column(
        children: [
          Expanded(
              child:
                  FirebaseAnimatedList(query: ref, itemBuilder: (context, snapshot, animation, index){
                    return ListTile(
                      title: Text(snapshot.child(path))
                    );
                  }
                
                  ))
        ],
      ),
    );
  }
}
