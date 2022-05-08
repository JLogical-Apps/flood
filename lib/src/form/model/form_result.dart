class FormResult {
  final Map<String, dynamic>? valueByName;

  const FormResult({required this.valueByName});

  bool get isValid => valueByName != null;

  Map<String, dynamic> get data => valueByName!;
}
