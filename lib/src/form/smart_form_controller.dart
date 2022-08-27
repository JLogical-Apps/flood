import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import 'smart_form.dart';
import 'smart_form_data.dart';
import 'validation/validation.dart';
import 'validation/validation_result.dart';

/// Controls the streams for a SmartForm.
class SmartFormController {
  /// Stream that maps the name of each field to its value. Updated whenever a field changes.
  final BehaviorSubject<Map<String, SmartFormData>> _dataByNameX;
  late final ValueStream<Map<String, SmartFormData>> dataByNameX = _dataByNameX;

  Map<String, SmartFormData> get dataByName => _dataByNameX.value;

  late ValueStream<Map<String, dynamic>> valueByNameX =
      dataByNameX.mapWithValue((dataByName) => dataByName.map((name, data) => MapEntry(name, data.value)));

  /// Maps each field to its value.
  Map<String, dynamic> get valueByName => dataByName.map((name, data) => MapEntry(name, data.value));

  /// Validator to use after all other fields have been checked.
  PostValidator? postValidator;

  SmartFormController() : _dataByNameX = BehaviorSubject.seeded({});

  /// Registers a form field with the controller.
  void registerFormField<T>({
    required String name,
    required T initialValue,
    required bool enabled,
    required List<Validation<T>> validators,
  }) {
    if (dataByName.containsKey(name)) return; // If a field with [name] already exists, just take on its value.

    _dataByNameX.value = dataByName.copy()
      ..addAll({
        name: SmartFormData<T>(
          value: initialValue,
          error: null,
          enabled: enabled,
          validators: validators,
        )
      });
  }

  /// Returns the stream of data for the form field of [name].
  ValueStream<SmartFormData<T>> getFormDataX<T>(String name) {
    return _dataByNameX.mapWithValue((dataByName) =>
        (dataByName[name] ?? (throw Exception('Cannot find form field with name: [$name]'))) as SmartFormData<T>);
  }

  /// Validates the fields in the form.
  /// Returns whether all the fields are validated.
  Future<ValidationResult> validate() async {
    _clearErrors();

    var foundError = false;

    // Check each enabled form field's validator.
    for (var entry in dataByName.entries.where((entry) => entry.value.enabled)) {
      var name = entry.key;
      var smartFormData = entry.value;

      for (var validator in smartFormData.validators) {
        var error = await validator.validate(smartFormData.value, this);
        if (error != null) {
          foundError = true;
          setError(name: name, error: error);
          break;
        }
      }
    }

    // If any of the fields had errors, return early.
    if (foundError) {
      return ValidationResult.failure();
    }

    // Check the post validator.
    var errors = await postValidator?.call(valueByName);

    // If the post validator returned null or an empty map, it was a success.
    if (errors == null || errors.isEmpty) return ValidationResult.success(valueByName);

    _setFieldErrors(errors);

    return ValidationResult.failure();
  }

  /// Returns the value of the form field with the [name].
  T getData<T>(String name) {
    return valueByName[name] as T;
  }

  T? getDataOrNull<T>(String name) {
    return valueByName[name] as T?;
  }

  /// Sets the value of the form field with [name] to [value].
  void setData<T>({required String name, required T value}) {
    var smartFormData = dataByName[name] ?? (throw Exception('Form field with name: [$name] not found!'));
    var newDataByName = dataByName.copy();
    newDataByName[name] = smartFormData.copyWith(
      value: value,
      error: smartFormData.error,
      enabled: smartFormData.enabled,
    );
    _dataByNameX.value = newDataByName;
  }

  /// Returns the error of the form field with the [name].
  String? getError(String name) {
    return getFormDataX(name).value.error;
  }

  /// Sets the error of the form field with [name] to [error].
  void setError({required String name, required String? error}) {
    var smartFormData = dataByName[name] ?? (throw Exception('Form field with name: [$name] not found!'));
    var newDataByName = dataByName.copy();
    newDataByName[name] =
        smartFormData.copyWith(value: smartFormData.value, error: error, enabled: smartFormData.enabled);
    _dataByNameX.value = newDataByName;
  }

  /// Sets whether the field is enabled.
  void setEnabled({required String name, required bool enabled}) {
    var smartFormData = dataByName[name] ?? (throw Exception('Form field with name: [$name] not found!'));
    var newDataByName = dataByName.copy();
    newDataByName[name] = smartFormData.copyWith(
      value: smartFormData.value,
      error: smartFormData.error,
      enabled: enabled,
    );
    _dataByNameX.value = newDataByName;
  }

  /// Clears all the errors in the form.
  void _clearErrors() {
    _dataByNameX.value = dataByName.copy(
        valueCopier: (smartFormData) => smartFormData.copyWith(
              value: smartFormData.value,
              error: null,
              enabled: smartFormData.enabled,
            ));
  }

  /// Sets the errors of the fields based on the [errors] given.
  void _setFieldErrors(Map<String, String> errors) {
    errors.forEach((name, error) => setError(name: name, error: error));
  }
}
