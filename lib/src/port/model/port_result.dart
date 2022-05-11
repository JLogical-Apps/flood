class PortResult {
  final Map<String, dynamic>? valueByName;

  const PortResult({required this.valueByName});

  bool get isValid => valueByName != null;

  Map<String, dynamic> get data => valueByName!;
}
