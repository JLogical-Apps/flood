import 'dart:async';

import 'package:jlogical_utils/src/port/model/port_component.dart';
import 'package:jlogical_utils/src/port/model/port_value_component.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../patterns/export_core.dart';
import 'port_field.dart';
import 'port_result.dart';
import 'validation/port_field_validation_context.dart';

class Port implements Validator<void> {
  final List<PortComponent> components;

  List<PortField> get fields => components.whereType<PortField>().toList();

  List<PortValueComponent> get valueComponents => components.whereType<PortValueComponent>().toList();

  final BehaviorSubject<Map<String, dynamic>> _valueByNameX;

  ValueStream<Map<String, dynamic>> get valueByNameX => _valueByNameX;

  final Map<String, dynamic> _valueByName;

  /// Predicate for whether to validate this.
  /// By default, always validates.
  bool Function(Port port) validationPredicate = _defaultValidationPredicate;

  Port({List<PortComponent>? fields})
      : components = [...?fields],
        _valueByNameX = BehaviorSubject.seeded({}),
        _valueByName = {} {
    fields?.forEach((field) => withComponent(field));
  }

  Port withComponent(PortComponent component) {
    components.add(component);
    if (component is PortValueComponent) {
      _valueByNameX.value = _valueByNameX.value.copy()..set(component.name, component.initialValue);
      _valueByName[component.name] = component.initialValue;
    }
    component.initialize(this);
    return this;
  }

  Port withField(PortField field) {
    return withComponent(field);
  }

  Port validateIf(bool predicate(Port port)) {
    validationPredicate = predicate;
    return this;
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

  PortValueComponent getValueComponentByName(String componentName) {
    return valueComponents.firstWhere((component) => component.name == componentName);
  }

  PortField getFieldByName(String fieldName) {
    return getValueComponentByName(fieldName) as PortField;
  }

  ValueStream<V> getFieldValueXByName<V>(String fieldName) {
    return getFieldByName(fieldName).valueX as ValueStream<V>;
  }

  Future<PortResult> submit() async {
    if (!await isValid(null)) {
      return PortResult(valueByName: null);
    }

    final submittedValues = await Future.wait(
        _valueByName.mapToIterable((name, value) async => await getValueComponentByName(name).submitMapper(value)));
    var submittedValueByName = Map.fromIterables(_valueByName.keys, submittedValues);

    return PortResult(valueByName: submittedValueByName);
  }

  @override
  Future onValidate(_) async {
    final shouldValidate = validationPredicate(this);
    if (!shouldValidate) {
      return;
    }

    for (final component in valueComponents) {
      if (component is! Validator<PortFieldValidationContext>) {
        continue;
      }

      final validator = component as Validator<PortFieldValidationContext>;
      final fieldValidationContext = PortFieldValidationContext(value: _valueByName[component.name], port: this);
      await validator.validate(fieldValidationContext);
    }
  }
}

bool _defaultValidationPredicate(Port port) {
  return true;
}
