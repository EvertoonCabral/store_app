class PagedResult<T> {
  final List<T> items;
  final int? totalItems;
  final int pageNumber;
  final int pageSize;
  final int totalPages;

  PagedResult({
    required this.items,
    required this.totalItems,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
  });

  factory PagedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final itemsJson = (json['items'] as List).cast<Map<String, dynamic>>();
    return PagedResult(
      items: itemsJson.map(fromJsonT).toList(),
      totalItems: json['totalCount'] as int,
      pageNumber: json['pageNumber'] as int,
      pageSize: json['pageSize'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}
