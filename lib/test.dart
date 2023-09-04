import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/functions.dart';

class ListaImoveis extends StatefulWidget {
  @override
  _ListaImoveisState createState() => _ListaImoveisState();
}

class _ListaImoveisState extends State<ListaImoveis> {
  List<Map<String, dynamic>> imoveis = List.generate(100, (index) {
    List<Map<String, dynamic>> imoveisParaIndex = [];

    // Adicione mais exemplos para cada índice
    for (int i = 0; i < 5; i++) {
      imoveisParaIndex.add({
        'imageURL':
            'https://empreenderdinheiro.com.br/wp-content/uploads/2019/06/comprar-terreno-2-1024x683.jpg.webp',
        'street': 'Rua Joaquim Lopes $index - Exemplo $i',
        'number': '$index',
        'owner': 'Fulano da Silva $index - Exemplo $i',
      });
    }

    return imoveisParaIndex;
  }).expand((element) => element).toList();

  TextEditingController indexController = TextEditingController();

  void atualizarImovel(Map<String, dynamic> novoImovel) {
    int index = imoveis
        .indexWhere((imovel) => imovel['number'] == novoImovel['number']);

    if (index != -1) {
      imoveis[index] = novoImovel;
      setState(() {});
    }
  }

  void filtrarPorIndex() {
    String indexText = indexController.text;
    int? selectedIndex = int.tryParse(indexText); // Altere para int?

    if (selectedIndex != null) {
      List<Map<String, dynamic>> filteredImoveis = imoveis
          .where((imovel) => imovel['number'] == selectedIndex.toString())
          .toList();

      setState(() {
        imoveis = filteredImoveis;
      });
    }
  }

  // Função para organizar os imóveis em blocos com base no índice do número
  Map<String, List<Map<String, dynamic>>> organizarEmBlocos() {
    Map<String, List<Map<String, dynamic>>> blocos = {};

    for (int i = 0; i < imoveis.length; i++) {
      String numero = imoveis[i]['number'];
      if (!blocos.containsKey(numero)) {
        blocos[numero] = [];
      }
      blocos[numero]!.add(imoveis[i]);
    }

    return blocos;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> blocos = organizarEmBlocos();

    return Scaffold(
      appBar: appBarDinamica(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: indexController,
              decoration: InputDecoration(
                labelText: 'Filtrar por número do imóvel',
                suffixIcon: IconButton(
                  icon: Icon(Icons.filter_alt),
                  onPressed: filtrarPorIndex,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: blocos.length,
              itemBuilder: (context, index) {
                String numero = blocos.keys.elementAt(index);
                List<Map<String, dynamic>> blocosImoveis = blocos[numero]!;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Bloco $numero',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: blocosImoveis.length,
                      itemBuilder: (context, index) {
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
                                    imovel: blocosImoveis[index],
                                    onUpdate: atualizarImovel),
                              ));
                            },
                            leading: Image.network(
                              blocosImoveis[index]['imageURL'],
                              height: 100,
                              width: 100,
                            ),
                            title: Text(
                              blocosImoveis[index]['street'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              blocosImoveis[index]['number'],
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
                                      blocosImoveis[index]['owner'],
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ImovelDetalhes extends StatelessWidget {
  final Map<String, dynamic> imovel;
  final Function(Map<String, dynamic>) onUpdate;

  ImovelDetalhes({required this.imovel, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Imóvel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Endereço: ${imovel['street']}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Número: ${imovel['number']}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Proprietário: ${imovel['owner']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      EditarImovel(imovel: imovel, onUpdate: onUpdate),
                ));
                Navigator.of(context).popUntil(
                    (route) => route.isFirst); // Volta para a tela inicial.
              },
              child: Text('Editar Imóvel'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditarImovel extends StatefulWidget {
  final Map<String, dynamic> imovel;
  final Function(Map<String, dynamic>) onUpdate;

  EditarImovel({required this.imovel, required this.onUpdate});

  @override
  _EditarImovelState createState() => _EditarImovelState();
}

class _EditarImovelState extends State<EditarImovel> {
  TextEditingController streetController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController ownerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    streetController.text = widget.imovel['street'];
    numberController.text = widget.imovel['number'];
    ownerController.text = widget.imovel['owner'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Imóvel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: streetController,
              decoration: InputDecoration(labelText: 'Endereço'),
            ),
            TextFormField(
              controller: numberController,
              decoration: InputDecoration(labelText: 'Número'),
            ),
            TextFormField(
              controller: ownerController,
              decoration: InputDecoration(labelText: 'Proprietário'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.imovel['street'] = streetController.text;
                widget.imovel['number'] = numberController.text;
                widget.imovel['owner'] = ownerController.text;

                widget.onUpdate(widget.imovel);

                Navigator.of(context).pop(); // Volta para a tela de detalhes.
              },
              child: Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
