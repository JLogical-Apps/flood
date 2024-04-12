import 'dart:async';

import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/port_mapper.dart';
import 'package:port_core/src/port_submit_result.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class Port<T> {
  ValueStream<Map<String, PortField>> getPortX();

  void setPortField({required String name, required PortField portField});

  Type get submitType;

  Future<PortSubmitResult<T>> submit();

  static Port<Map<String, dynamic>> of(Map<String, PortField> portFieldByName) => _PortImpl(portFieldByName);

  static Port<T?> empty<T>() => _PortImpl({}).map((port, values) => null);
}

extension PortExtensions<T> on Port<T> {
  Map<String, PortField> get portFieldByName => getPortX().value;

  Map<String, dynamic> get portValueByName => portFieldByName.map((name, field) => MapEntry(name, field.value));

  PortField? getFieldByNameOrNull(String name) => portFieldByName[name];

  PortField getFieldByName(String name) =>
      getFieldByNameOrNull(name) ?? (throw Exception('Cannot find port field with name [$name]'));

  F? getByNameOrNull<F>(String name) => portFieldByName[name]?.value;

  F getByName<F>(String name) => (portFieldByName[name] ?? (throw Exception('Cannot find value [$name]'))).value;

  dynamic getErrorByNameOrNull(String name) => portFieldByName[name]?.error;

  dynamic getErrorByName(String name) =>
      (portFieldByName[name] ?? (throw Exception('Cannot find value [$name]'))).error;

  void setValue({required String name, required dynamic value}) {
    final field = getFieldByName(name);
    final parsedValue = field.parseValue(value);
    setPortField(
      name: name,
      portField: field.copyWithValue(parsedValue),
    );
  }

  void setError({required String name, required dynamic error}) => setPortField(
        name: name,
        portField: getFieldByName(name).copyWithError(error),
      );

  void clearError({required String name}) => setError(name: name, error: null);

  dynamic operator [](String name) => getByName(name);

  operator []=(String name, dynamic value) => setValue(name: name, value: value);

  PortMapper<T, R> map<R>(FutureOr<R?> Function(T sourceData, Port<T> port) mapper, {Type? submitType}) {
    return PortMapper(port: this, mapper: mapper, submitType: submitType);
  }
}

mixin IsPort<T> implements Port<T> {}

class _PortImpl with IsPort<Map<String, dynamic>> {
  final BehaviorSubject<Map<String, PortField>> _portFieldByNameX;

  _PortImpl(Map<String, PortField> valueByName) : _portFieldByNameX = BehaviorSubject.seeded(valueByName) {
    for (final portField in valueByName.values) {
      portField.registerToPort(this);
    }
  }

  Map<String, PortField> get portFieldByName => _portFieldByNameX.value;

  set portFieldByName(Map<String, PortField> value) {
    _portFieldByNameX.value = value;
  }

  @override
  ValueStream<Map<String, PortField>> getPortX() => _portFieldByNameX;

  @override
  void setPortField({required String name, required PortField portField}) {
    portFieldByName = portFieldByName.copy()..set(name, portField);
  }

  @override
  Type get submitType => typeOf<Map<String, dynamic>>();

  @override
  Future<PortSubmitResult<Map<String, dynamic>>> submit() async {
    var hasError = false;
    for (final portFieldByNameEntry in portFieldByName.entries) {
      final name = portFieldByNameEntry.key;
      final portField = portFieldByNameEntry.value;

      final error = await portField.validate(portField.createValidationContext());
      final newField = portField.copyWithError(error);
      setPortField(name: name, portField: newField);

      if (error != null) {
        hasError = true;
      }
    }

    if (hasError) {
      return PortSubmitResult(data: null);
    }

    final submitValueByNameEntries = await Future.wait(portFieldByName
        .mapToIterable((name, portField) async => MapEntry(name, await portField.submit(portField.getOrNull()))));
    return PortSubmitResult(data: submitValueByNameEntries.toMap());
  }
}

abstract class PortWrapper<T> implements Port<T> {
  Port<T> get port;
}

mixin IsPortWrapper<T> implements PortWrapper<T> {
  @override
  ValueStream<Map<String, PortField>> getPortX() => port.getPortX();

  @override
  void setPortField({required String name, required PortField portField}) =>
      port.setPortField(name: name, portField: portField);

  @override
  Future<PortSubmitResult<T>> submit() => port.submit();
}
