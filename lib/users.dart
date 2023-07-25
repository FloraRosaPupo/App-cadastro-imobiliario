import 'package:firebase_database/firebase_database.dart';

class Dados {
  final int SIAT;
  final String nome;
  final String cpf_cnpj;
  final String rua;
  final String numero_casa;
  final int quarteirao;
  final String data;
  //final String horas;

  const Dados({
    required this.SIAT,
    required this.nome,
    required this.cpf_cnpj,
    required this.rua,
    required this.numero_casa,
    required this.quarteirao,
    required this.data,
    //required this.horas,
  });

  Dados copy({
    int? SIAT,
    String? nome,
    String? cpf_cnpj,
    String? rua,
    String? numero_casa,
    int? quarteirao,
    String? data,
   // String? horas,
  }) =>
      Dados(
        SIAT: SIAT ?? this.SIAT,
        nome: nome ?? this.nome,
        cpf_cnpj: cpf_cnpj ?? this.cpf_cnpj,
        rua: rua ?? this.rua,
        numero_casa: numero_casa ?? this.numero_casa,
        quarteirao: quarteirao ?? this.quarteirao,
        data: data ?? this.data,
        //horas: horas ?? this.horas,
      );
}

List<Dados> allDados = []; // Inicializa a lista vazia

void buscarDadosEmTempoReal() {
  final databaseReference =
      FirebaseDatabase.instance.reference().child('imoveis');

  databaseReference.onValue.listen((event) {
    final data = event.snapshot.value as Map<dynamic, dynamic>;
    allDados
        .clear(); // Limpa a lista para atualizar com novos dados em tempo real

    data.forEach((key, value) {
      allDados.add(Dados(
        SIAT: value['Inscrição Siat'],
        nome: value['Nome'],
        cpf_cnpj: value['CPF'],
        rua: value['Rua'],
        numero_casa: value['Nº'],
        quarteirao: value['Quarteirão'],
        data: value['Data 1'],
        //horas: value['horas'],
      ));
    });
  });
}

// Para utilizar os dados em tempo real, basta chamar a função buscarDadosEmTempoReal() no arquivo desejado.
// Por exemplo:
// main() {
//   buscarDadosEmTempoReal();
//   print(allDados);
// }
