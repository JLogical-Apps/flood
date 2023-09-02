class PortSubmitResult<T> {
  final T? _data;

  PortSubmitResult({T? data}) : _data = data;

  bool get isValid => _data != null;

  T get data => _data!;

  T? get dataOrNull => _data;
}
