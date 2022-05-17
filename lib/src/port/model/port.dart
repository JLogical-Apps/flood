import 'dart:async';

import 'package:jlogical_utils/src/port/model/port_component.dart';
import 'package:jlogical_utils/src/port/model/port_value_component.dart';
import 'package:jlogical_utils/src/port/model/validation/port_field_validation_exception.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../patterns/export_core.dart';
import '../config/port_config.dart';
import 'port_field.dart';
import 'port_result.dart';
import 'validation/port_field_validation_context.dart';
import 'validation/port_submit_exception.dart';

/// [T] is the value that is returned when submitted. By default, returns a Map<String, dynamic> but can be overridden
/// by calling [withSubmitMapper].
class Port<T> implements Validator<void> {
  static PortConfig config = PortConfig();

  final List<PortComponent> components = [];

  List<PortField> get fields => components.whereType<PortField>().toList();

  List<PortValueComponent> get valueComponents => components.whereType<PortValueComponent>().toList();

  final BehaviorSubject<Map<String, dynamic>> _valueByNameX = BehaviorSubject.seeded({});

  ValueStream<Map<String, dynamic>> get valueByNameX => _valueByNameX;

  final Map<String, dynamic> _valueByName = {};

  final BehaviorSubject<Map<String, dynamic>> _exceptionByNameX = BehaviorSubject.seeded({});

  ValueStream<Map<String, dynamic>> get exceptionByNameX => _exceptionByNameX;

  final Map<String, dynamic> _exceptionByName = {};

  /// Predicate for whether to validate this.
  /// By default, always validates.
  bool Function(Port port) _validationPredicate = _defaultValidationPredicate;

  final List<Validator<Port>> _additionalValidators = [];

  /// Maps the result to another value.
  T Function(Map<String, dynamic> resultValueByName)? _submitMapper;

  Port({List<PortComponent>? fields}) {
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
    _validationPredicate = predicate;
    return this;
  }

  Port withValidator(Validator<Port> validator) {
    _additionalValidators.add(validator);
    return this;
  }

  Port withSubmitMapper(T submitMapper(Map<String, dynamic> resultValueByName)) {
    this._submitMapper = submitMapper;
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
    return valueByNameX.mapWithValue((valueByName) => valueByName[fieldName]);
  }

  Object? getExceptionByName(String fieldName) {
    return _exceptionByName[fieldName];
  }

  void setException({required String name, required dynamic exception}) {
    _exceptionByNameX.value = _exceptionByNameX.value.copy()..set(name, exception);
    _exceptionByName[name] = exception;
  }

  ValueStream<Object?> getExceptionXByName(String fieldName) {
    return exceptionByNameX.mapWithValue((exceptionByName) => exceptionByName[fieldName]);
  }

  Future<PortResult> submit() async {
    final exception = await getException(null);
    if (exception != null) {
      if (exception is! PortSubmitException) {
        throw exception;
      }

      _exceptionByName.clear();
      exception.fieldExceptionByName.forEach((name, exception) {
        _exceptionByName[name] = exception;
      });

      _exceptionByNameX.value = _exceptionByName;

      return PortResult(exception: exception);
    }

    final submittedValues = await Future.wait(
        _valueByName.mapToIterable((name, value) async => await getValueComponentByName(name).submitMapper(value)));
    var submittedValueByName = Map.fromIterables(_valueByName.keys, submittedValues);

    dynamic result = submittedValueByName;
    if (_submitMapper != null) {
      result = _submitMapper!(result);
    }

    return PortResult(result: result);
  }

  @override
  Future onValidate(_) async {
    final shouldValidate = _validationPredicate(this);
    if (!shouldValidate) {
      return;
    }

    var errorByName = <String, dynamic>{};

    for (final component in valueComponents) {
      if (component is! Validator<PortFieldValidationContext>) {
        continue;
      }

      final validator = component as Validator<PortFieldValidationContext>;
      final fieldValidationContext = PortFieldValidationContext(value: _valueByName[component.name], port: this);
      final error = await validator.getException(fieldValidationContext);
      if (error != null) {
        errorByName[component.name] = error;
      }
    }

    for (final validator in _additionalValidators) {
      final exception = await validator.getException(this);
      if (exception == null) {
        continue;
      }

      if (exception is! PortFieldValidationException) {
        throw exception;
      }

      errorByName[exception.failedValue] = exception.exception;
    }

    if (errorByName.isNotEmpty) {
      throw PortSubmitException(fieldExceptionByName: errorByName, failedValue: this);
    }
  }
}

bool _defaultValidationPredicate(Port port) {
  return true;
}
