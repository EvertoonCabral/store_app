enum StatusVenda {
  pendente(1),
  finalizada(2),
  cancelada(3);

  final int value;
  const StatusVenda(this.value);

  static StatusVenda fromAny(dynamic linha) {
    if (linha == null) {
      throw ArgumentError('StatusVenda nulo');
    }

    final s = linha.trim();

    final asInt = int.tryParse(s);
    if (asInt != null) {
      return fromValue(asInt);
    }

    switch (s.toLowerCase()) {
      case 'pendente':
        return StatusVenda.pendente;
      case 'finalizada':
        return StatusVenda.finalizada;
      case 'cancelada':
        return StatusVenda.cancelada;
    }

    throw ArgumentError('StatusVenda inválido: $linha (${linha.runtimeType})');
  }

  static StatusVenda fromValue(int value) {
    switch (value) {
      case 1:
        return StatusVenda.pendente;
      case 2:
        return StatusVenda.finalizada;
      case 3:
        return StatusVenda.cancelada;
      default:
        throw ArgumentError('StatusVenda inválido: $value');
    }
  }
}
