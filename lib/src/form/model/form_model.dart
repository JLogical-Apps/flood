import 'dart:async';

import 'package:jlogical_utils/src/form/model/validation/form_field_validation_context.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../patterns/export_core.dart';
import 'form_field_model.dart';
import 'form_result.dart';

class FormModel implements Validator<void> {
  final List<FormFieldModel> fields;

  final BehaviorSubject<Map<String, dynamic>> _valueByNameX;

  Map<String, dynamic> get valueByName => _valueByNameX.value;

  FormModel({required this.fields}) : _valueByNameX = BehaviorSubject.seeded(_initialValueByName(fields)) {
    fields.forEach((field) => field.valueX = _valueByNameX.mapWithValue((valueByName) => valueByName[field.name]));
  }

  dynamic operator [](String fieldName) {
    return get(fieldName);
  }

  operator []=(String fieldName, dynamic value) {
    set(fieldName, value);
  }

  V get<V>(String fieldName) {
    return getFieldByName(fieldName).value;
  }

  void set(String fieldName, dynamic value) {
    _valueByNameX.value = _valueByNameX.value.copy()..set(fieldName, value);
  }

  FormFieldModel getFieldByName(String fieldName) {
    return fields.firstWhere((field) => field.name == fieldName);
  }

  Future<FormResult> submit() async {
    if (!await isValid(null)) {
      return FormResult(valueByName: null);
    }

    return FormResult(valueByName: valueByName);
  }

  @override
  Future onValidate(void empty) async {
    for (final field in fields) {
      final fieldValidationContext = FormFieldValidationContext(value: valueByName[field.name], form: this);
      await field.onValidate(fieldValidationContext);
    }
  }

  static Map<String, dynamic> _initialValueByName(List<FormFieldModel> fields) {
    return fields.map((field) => MapEntry(field.name, field.initialValue)).toMap();
  }
}
