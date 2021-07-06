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

  const SmartFormData({required this.value, this.error, required this.validators});

  SmartFormData copyWith({required T value, required String? error}) {
    return SmartFormData(value: value, error: error, validators: validators);
  }
}
