import 'package:flutter/material.dart';

class Galeria extends StatefulWidget {
  const Galeria({super.key});

  @override
  State<Galeria> createState() => _GaleriaState();
}

class _GaleriaState extends State<Galeria> {
  //List<String> ids = [];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        return Image.network(
            'https://drive.google.com/file/d/1K-Yzvcl0NGmQuTzPQOEyIyucIUrCqO_Z/view?usp=sharing');
      },
      //itemCount: ids.length,
    );
  }
}
