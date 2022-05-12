class PortResult {
  final Map<String, dynamic>? valueByName;

  const PortResult({required this.valueByName});

  bool get isValid => valueByName != null;

  operator [](String name) {
    return valueByName![name];
  }
}
