import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/functions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListView Example',
      home: ListaImoveis(),
    );
  }
}

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

  int blocoAtual = 1; // Índice do bloco atual
  int itensPorBloco = 10; // Número de itens por bloco

  void atualizarImovel(Map<String, dynamic> novoImovel) {
    int index = imoveis
        .indexWhere((imovel) => imovel['number'] == novoImovel['number']);

    if (index != -1) {
      imoveis[index] = novoImovel;
      setState(() {});
    }
  }

  List<Map<String, dynamic>> getImoveisDoBloco(int bloco) {
    final startIndex = (bloco - 1) * itensPorBloco;
    final endIndex = startIndex + itensPorBloco;
    return imoveis.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    final imoveisDoBloco = getImoveisDoBloco(blocoAtual);

    return Scaffold(
      appBar: appBarDinamica(),
      body: Column(
        children: [
          // Botões de navegação entre os blocos
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (blocoAtual > 1) {
                      blocoAtual--;
                    }
                  });
                },
                icon: Icon(Icons.arrow_back), // Ícone de seta para esquerda
              ),
              Text('Bloco $blocoAtual'),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (blocoAtual < (imoveis.length / itensPorBloco).ceil()) {
                      blocoAtual++;
                    }
                  });
                },
                icon: Icon(Icons.arrow_forward), // Ícone de seta para direita
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: imoveisDoBloco.length,
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
                            imovel: imoveisDoBloco[index],
                            onUpdate: atualizarImovel),
                      ));
                    },
                    leading: Image.network(
                      imoveisDoBloco[index]['imageURL'],
                      height: 100,
                      width: 100,
                    ),
                    title: Text(
                      imoveisDoBloco[index]['street'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      imoveisDoBloco[index]['number'],
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
                              imoveisDoBloco[index]['owner'],
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
      appBar: appBarDinamica(),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - kToolbarHeight,
        ),
        child: SingleChildScrollView(
          child: Padding(
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
      appBar: appBarDinamica(),
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
