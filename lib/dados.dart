import 'package:firebase_database/firebase_database.dart';

class Dados {
  final String SIAT;
  final String nome;
  final String cpf;
  final String caracterizacao;
  final String celular;
  final String cobertura;
  final String contribuinte;
  final String coordenadas;
  final String data1;
  final String data2;
  final String data3;
  final String dataNascimento;
  final String fotoAerea;
  final String fotoFrontal;
  final String horario1;
  final String horario2;
  final String horario3;
  final String numero;
  final String numPavimentos;
  final String observacao;
  final String piso;
  final String quarteirao;
  final String responsavelCadastro;
  final String rua;
  //final int sequencia;
  final String situacao;
  final String visita;
  final String id;

  const Dados({
    required this.SIAT,
    required this.nome,
    required this.cpf,
    required this.caracterizacao,
    required this.celular,
    required this.cobertura,
    required this.contribuinte,
    required this.coordenadas,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.dataNascimento,
    required this.fotoAerea,
    required this.fotoFrontal,
    required this.horario1,
    required this.horario2,
    required this.horario3,
    required this.numero,
    required this.numPavimentos,
    required this.observacao,
    required this.piso,
    required this.quarteirao,
    required this.responsavelCadastro,
    required this.rua,
    //required this.sequencia,
    required this.situacao,
    required this.visita,
    required this.id,
  });

  Dados copy({
    String? SIAT,
    String? nome,
    String? cpf,
    String? caracterizacao,
    String? celular,
    String? cobertura,
    String? contribuinte,
    String? coordenadas,
    String? data1,
    String? data2,
    String? data3,
    String? dataNascimento,
    String? fotoAerea,
    String? fotoFrontal,
    String? horario1,
    String? horario2,
    String? horario3,
    String? numero,
    String? numPavimentos,
    String? observacao,
    String? piso,
    String? quarteirao,
    String? responsavelCadastro,
    String? rua,
    //int? sequencia,
    String? situacao,
    String? visita,
    String? id,
  }) =>
      Dados(
        SIAT: SIAT ?? this.SIAT,
        nome: nome ?? this.nome,
        cpf: cpf ?? this.cpf,
        caracterizacao: caracterizacao ?? this.caracterizacao,
        celular: celular ?? this.celular,
        cobertura: cobertura ?? this.cobertura,
        contribuinte: contribuinte ?? this.contribuinte,
        coordenadas: coordenadas ?? this.coordenadas,
        data1: data1 ?? this.data1,
        data2: data2 ?? this.data2,
        data3: data3 ?? this.data3,
        dataNascimento: dataNascimento ?? this.dataNascimento,
        fotoAerea: fotoAerea ?? this.fotoAerea,
        fotoFrontal: fotoFrontal ?? this.fotoFrontal,
        horario1: horario1 ?? this.horario1,
        horario2: horario2 ?? this.horario2,
        horario3: horario3 ?? this.horario3,
        numero: numero ?? this.numero,
        numPavimentos: numPavimentos ?? this.numPavimentos,
        observacao: observacao ?? this.observacao,
        piso: piso ?? this.piso,
        quarteirao: quarteirao ?? this.quarteirao,
        responsavelCadastro: responsavelCadastro ?? this.responsavelCadastro,
        rua: rua ?? this.rua,
        //sequencia: sequencia ?? this.sequencia,
        situacao: situacao ?? this.situacao,
        visita: visita ?? this.visita,
        id: id ?? this.id,
      );

  // Método para converter um mapa em um objeto Dados
  factory Dados.fromMap(Map<dynamic, dynamic> map) {
    return Dados(
      SIAT: map['SIAT'] as String,
      nome: map['nome'] as String,
      cpf: map['cpf'] as String,
      caracterizacao: map['caracterizacao'] as String,
      celular: map['celular'] as String,
      cobertura: map['cobertura'] as String,
      contribuinte: map['contribuinte'] as String,
      coordenadas: map['coordenadas'] as String,
      data1: map['data1'] as String,
      data2: map['data2'] as String,
      data3: map['data3'] as String,
      dataNascimento: map['dataNascimento'] as String,
      fotoAerea: map['fotoAerea'] as String,
      fotoFrontal: map['fotoFrontal'] as String,
      horario1: map['horario1'] as String,
      horario2: map['horario2'] as String,
      horario3: map['horario3'] as String,
      numero: map['numero'] as String,
      numPavimentos: map['numPavimentos'] as String,
      observacao: map['observacao'] as String,
      piso: map['piso'] as String,
      quarteirao: map['quarteirao'] as String,
      responsavelCadastro: map['responsavelCadastro'] as String,
      rua: map['rua'] as String,
      //sequencia: map['sequencia'] as int,
      situacao: map['situacao'] as String,
      visita: map['visita'] as String,
      id: map['id'] as String,
    );
  }
}

class FirebaseDataManager {
  final DatabaseReference _imoveisRef =
      FirebaseDatabase.instance.reference().child('imoveis');

  Stream<List<Dados>> buscarDadosImoveis() {
    return _imoveisRef.onValue.map((event) {
      if (event.snapshot.value != null) {
        final dynamic values = event.snapshot.value;
        if (values is Map<String, dynamic>) {
          List<Dados> imoveis = [];
          values.forEach((key, value) {
            imoveis.add(Dados.fromMap(
                value)); // Certifique-se de que Dados.fromMap está configurado corretamente
          });
          return imoveis;
        }
      }
      return <Dados>[];
    });
  }
}
