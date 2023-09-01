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
                              imovel: imoveis[index],
                              onUpdate: atualizarImovel),
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
