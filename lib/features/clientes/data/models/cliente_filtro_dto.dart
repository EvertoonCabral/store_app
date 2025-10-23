class ClienteFiltroDto {
  final int pageNumber;
  final int pageSize;

  const ClienteFiltroDto({this.pageNumber = 1, this.pageSize = 20});

  Map<String, dynamic> toQuery() => {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };
}
