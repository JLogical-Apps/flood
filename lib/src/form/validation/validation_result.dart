/// The result of a form validation.
class ValidationResult {
  /// Maps the name of each form-field to its value.
  final Map<String, dynamic>? valueByName;

  /// Whether the validation result was successful.
  bool get isValid => valueByName != null;

  /// A successful validation result.
  const ValidationResult.success(Map<String, dynamic> _valueByName) : valueByName = _valueByName;

  /// A validation result that represents a failure.
  const ValidationResult.failure() : valueByName = null;
}
