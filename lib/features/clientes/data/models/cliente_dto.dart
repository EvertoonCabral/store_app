class ClienteDto {
  final int id;
  final String nome;
  final String? cpf;
  final String telefone;
  final String? email;
  final bool isAtivo;
  final DateTime dataCadastro;

  ClienteDto({
    required this.id,
    required this.nome,
    this.cpf,
    required this.telefone,
    this.email,
    required this.isAtivo,
    required this.dataCadastro,
  });

  factory ClienteDto.fromJson(Map<String, dynamic> json) => ClienteDto(
        id: json['id'] as int,
        nome: json['nome'] as String,
        cpf: json['cpd'] as String,
        telefone: json['telefone'] as String,
        email: json['email'] as String,
        isAtivo: json['isAtivo'] as bool,
        dataCadastro: DateTime.parse(json['dataCadastro'] as String),
      );
}
