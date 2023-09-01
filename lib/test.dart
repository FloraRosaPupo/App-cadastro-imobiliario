import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/functions.dart';

class ListaImoveis extends StatefulWidget {
  @override
  _ListaImoveisState createState() => _ListaImoveisState();
}

class _ListaImoveisState extends State<ListaImoveis> {
  List<Map<String, dynamic>> imoveis = List.generate(100, (index) {
    return {
      'imageURL':
          'https://empreenderdinheiro.com.br/wp-content/uploads/2019/06/comprar-terreno-2-1024x683.jpg.webp',
      'street': 'Rua Joaquim Lopes $index',
      'number': '$index',
      'owner': 'Fulano da Silva $index',
    };
  });

  String filtro = '';

  void atualizarImovel(Map<String, dynamic> novoImovel) {
    int index = imoveis
        .indexWhere((imovel) => imovel['number'] == novoImovel['number']);

    if (index != -1) {
      imoveis[index] = novoImovel;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDinamica(),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Filtrar por número',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                filtro = value;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: imoveis.length,
              itemBuilder: (context, index) {
                if (filtro.isEmpty ||
                    imoveis[index]['number']
                        .toLowerCase()
                        .contains(filtro.toLowerCase())) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black26,
                        width: 0.5,
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ImovelDetalhes(
                              imovel: imoveis[index], onUpdate: atualizarImovel),
                        ));
                      },
                      leading: Image.network(
                        imoveis[index]['imageURL'],
                        height: 100,
                        width: 100,
                      ),
                      title: Text(
                        imoveis[index]['street'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        imoveis[index]['number'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                imoveis[index]['owner'],
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox(); // Retorna um widget vazio se não corresponder ao filtro.
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
