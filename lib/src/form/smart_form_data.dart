import 'form.dart';

/// Stores the data for a smart form field.
class SmartFormData<T> {
  /// The value of the field.
  final T value;

  /// A validation error for this field.
  /// If null, then no error with this field.
  final String? error;

  /// The validators of the field.
  final List<Validation<T>> validators;

  /// Whether the form is enabled.
  final bool enabled;

  const SmartFormData({
    required this.value,
    this.error,
    required this.validators,
    required this.enabled,
  });

  SmartFormData copyWith({required T value, required String? error, required bool enabled}) {
    return SmartFormData(value: value, error: error, validators: validators, enabled: enabled);
  }
}
