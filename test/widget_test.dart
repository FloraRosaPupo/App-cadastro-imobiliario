import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_prefeitura/features/properties/domain/dados.dart';

void main() {
  test('edição preserva os demais dados do imóvel', () {
    final original = Dados.fromMap({
      'SIAT': '1',
      'nome': 'Flora',
      'cpf': '1',
      'caracterizacao': '1',
      'celular': '1',
      'cobertura': '1',
      'contribuinte': '1',
      'coordenadas': '1',
      'data1': '1',
      'data2': '1',
      'data3': '1',
      'dataNascimento': '1',
      'fotoAerea': '1',
      'fotoFrontal': '1',
      'horario1': '1',
      'horario2': '1',
      'horario3': '1',
      'numero': '1',
      'numPavimentos': '1',
      'observacao': '1',
      'piso': '1',
      'quarteirao': '1',
      'responsavelCadastro': '1',
      'rua': '1',
      'situacao': '1',
      'visita': '1',
      'id': '1'
    });
    final edited = original.copy(nome: 'Outro nome');
    expect(edited.nome, 'Outro nome');
    expect(original.nome, 'Flora');
    expect(edited.id, original.id);
    expect(edited.rua, original.rua);
  });
}
