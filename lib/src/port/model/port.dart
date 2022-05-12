import 'dart:async';

import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../patterns/export_core.dart';
import 'port_field.dart';
import 'port_result.dart';
import 'validation/port_field_validation_context.dart';

class Port implements Validator<void> {
  final List<PortField> fields;

  final BehaviorSubject<Map<String, dynamic>> _valueByNameX;

  ValueStream<Map<String, dynamic>> get valueByNameX => _valueByNameX;

  final Map<String, dynamic> _valueByName;

  Port({required this.fields})
      : _valueByNameX = BehaviorSubject.seeded(_initialValueByName(fields)),
        _valueByName = _initialValueByName(fields) {
    fields.forEach((field) => field.initialize(this));
  }

  dynamic operator [](String fieldName) {
    return get(fieldName);
  }

  operator []=(String fieldName, dynamic value) {
    set(fieldName, value);
  }

  V get<V>(String fieldName) {
    return _valueByName[fieldName];
  }

  void set(String fieldName, dynamic value) {
    _valueByName[fieldName] = value;
    _valueByNameX.value = _valueByNameX.value.copy()..set(fieldName, value);
  }

  PortField getFieldByName(String fieldName) {
    return fields.firstWhere((field) => field.name == fieldName);
  }

  ValueStream<V> getFieldValueXByName<V>(String fieldName) {
    return getFieldByName(fieldName).valueX as ValueStream<V>;
  }

  Future<PortResult> submit() async {
    if (!await isValid(null)) {
      return PortResult(valueByName: null);
    }

    return PortResult(valueByName: _valueByName);
  }

  @override
  Future onValidate(_) async {
    for (final field in fields) {
      final fieldValidationContext = PortFieldValidationContext(value: _valueByName[field.name], port: this);
      await field.validate(fieldValidationContext);
    }
  }

  static Map<String, dynamic> _initialValueByName(List<PortField> fields) {
    return fields.map((field) => MapEntry(field.name, field.initialValue)).toMap();
  }
}
