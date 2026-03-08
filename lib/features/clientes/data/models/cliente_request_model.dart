class ClienteRequestModel {
  final String nome;
  final String? cpf;
  final String telefone;
  final String? email;
  final bool isAtivo;

  const ClienteRequestModel({
    required this.nome,
    this.cpf,
    required this.telefone,
    this.email,
    this.isAtivo = true,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        if (cpf != null && cpf!.isNotEmpty) 'cpf': cpf,
        'telefone': telefone,
        if (email != null && email!.isNotEmpty) 'email': email,
        'isAtivo': isAtivo,
      };
}
