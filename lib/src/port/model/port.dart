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

  final BehaviorSubject<Map<String, dynamic>> _rawValueByNameX = BehaviorSubject.seeded({});

  ValueStream<Map<String, dynamic>> get rawValueByNameX => _rawValueByNameX;

  final Map<String, dynamic> _rawValueByName = {};

  final BehaviorSubject<Map<String, dynamic>> _fallbackByNameX = BehaviorSubject.seeded({});

  ValueStream<Map<String, dynamic>> get fallbackByNameX => _fallbackByNameX;

  final Map<String, dynamic> _fallbackByName = {};

  late ValueStream<Map<String, dynamic>> valueByNameX = _rawValueByNameX.mapWithValue(
      (rawValueByName) => rawValueByName.map((name, rawValue) => MapEntry(name, getFieldByName(name).value)));

  Map<String, dynamic> get valueByName =>
      _rawValueByName.map((name, rawValue) => MapEntry(name, getFieldByName(name).value));

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

  Port<T> withComponent(PortComponent component) {
    components.add(component);
    if (component is PortValueComponent) {
      set(component.name, component.initialValue);
      setFallback(component.name, component.initialFallback);
    }
    component.initialize(this);
    return this;
  }

  Port<T> withField(PortField field) {
    return withComponent(field);
  }

  Port<T> validateIf(bool predicate(Port port)) {
    _validationPredicate = predicate;
    return this;
  }

  Port<T> withValidator(Validator<Port> validator) {
    _additionalValidators.add(validator);
    return this;
  }

  Port<T> withSubmitMapper(T submitMapper(Map<String, dynamic> resultValueByName)) {
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
    return valueByName[fieldName];
  }

  dynamic getRaw(String fieldName) {
    return _rawValueByName[fieldName];
  }

  dynamic getFallback(String fieldName) {
    return _fallbackByName[fieldName];
  }

  void set(String fieldName, dynamic value) {
    _rawValueByName[fieldName] = value;

    final newRawValueByNameX = _rawValueByNameX.value.copy()..set(fieldName, value);
    _rawValueByNameX.value = newRawValueByNameX;
  }

  void setFallback(String fieldName, dynamic fallback) {
    _fallbackByName[fieldName] = fallback;
    _fallbackByNameX.value = _fallbackByNameX.value.copy()..set(fieldName, fallback);
  }

  PortValueComponent getValueComponentByName(String componentName) {
    return valueComponents.firstWhere((component) => component.name == componentName);
  }

  PortField getFieldByName(String fieldName) {
    return getValueComponentByName(fieldName) as PortField;
  }

  ValueStream<dynamic> getRawFieldValueXByName(String fieldName) {
    return _rawValueByNameX.mapWithValue((valueByName) => valueByName[fieldName]);
  }

  ValueStream<V> getFieldValueXByName<V>(String fieldName) {
    return valueByNameX.mapWithValue((valueByName) => valueByName[fieldName]);
  }

  ValueStream<dynamic> getFallbackXByName(String fieldName) {
    return _fallbackByNameX.mapWithValue((fallbackByName) => fallbackByName[fieldName]);
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

  Future<PortResult<T>> submit({bool throwExceptionIfFail: false}) async {
    _exceptionByName.clear();
    _exceptionByNameX.value = _exceptionByName;

    final exception = await getException(null);
    if (exception != null) {
      if (exception is! PortSubmitException) {
        throw exception;
      }

      exception.fieldExceptionByName.forEach((name, exception) {
        _exceptionByName[name] = exception;
      });

      _exceptionByNameX.value = _exceptionByName;

      if (throwExceptionIfFail) {
        throw exception;
      }

      return PortResult(exception: exception);
    }

    final submittedValues = await Future.wait(_rawValueByName.mapToIterable((name, value) async {
      final valueComponent = getValueComponentByName(name);
      return await valueComponent.submitMapper(valueComponent.value);
    }));
    var submittedValueByName = Map.fromIterables(_rawValueByName.keys, submittedValues);

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

      try {
        final validator = component as Validator<PortFieldValidationContext>;
        final fieldValidationContext = PortFieldValidationContext(
          value: component.value,
          port: this,
        );
        await validator.validate(fieldValidationContext);
      } catch (e) {
        errorByName[component.name] = e;
      }
    }

    if (errorByName.isNotEmpty) {
      throw PortSubmitException(fieldExceptionByName: errorByName, failedValue: this);
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
