abstract class ValidationException<V> {
  final V failedValue;

  ValidationException({required this.failedValue});
}
