import 'dart:async';

import 'package:port_core/src/port_mapper.dart';
import 'package:port_core/src/port_submit_result.dart';
import 'package:port_core/src/port_value.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class Port<T> {
  ValueStream<Map<String, PortValue>> getPortX();

  void setPortValue({required String name, required PortValue portValue});

  Future<PortSubmitResult<T>> submit();

  static Port<Map<String, dynamic>> of(Map<String, PortValue> portValueByName) => _PortImpl(portValueByName);
}

extension PortExtensions<T> on Port<T> {
  Map<String, PortValue> get portValueByName => getPortX().value;

  PortValue? getPortValueByNameOrNull(String name) => portValueByName[name];

  PortValue getPortValueByName(String name) =>
      getPortValueByNameOrNull(name) ?? (throw Exception('Cannot find port value with name [$name]'));

  F? getByNameOrNull<F>(String name) => portValueByName[name]?.getOrNull();

  F getByName<F>(String name) => (portValueByName[name] ?? (throw Exception('Cannot find value [$name]'))).getOrNull();

  dynamic getErrorByNameOrNull(String name) => portValueByName[name]?.error;

  dynamic getErrorByName(String name) =>
      (portValueByName[name] ?? (throw Exception('Cannot find value [$name]'))).error;

  void setValue({required String name, required dynamic value}) => setPortValue(
        name: name,
        portValue: getPortValueByName(name).copyWithValue(value),
      );

  void setError({required String name, required dynamic error}) => setPortValue(
        name: name,
        portValue: getPortValueByName(name).copyWithError(error),
      );

  dynamic operator [](String name) => getByName(name);

  operator []=(String name, dynamic value) => setValue(name: name, value: value);

  PortMapper<T, R> map<R>(FutureOr<R> Function(T sourceData, Port<T> port) mapper) {
    return PortMapper(port: this, mapper: mapper);
  }
}

mixin IsPort<T> implements Port<T> {}

class _PortImpl with IsPort<Map<String, dynamic>> {
  final BehaviorSubject<Map<String, PortValue>> _portValueByNameX;

  _PortImpl(Map<String, PortValue> valueByName) : _portValueByNameX = BehaviorSubject.seeded(valueByName);

  Map<String, PortValue> get portValueByName => _portValueByNameX.value;

  set portValueByName(Map<String, PortValue> value) {
    _portValueByNameX.value = value;
  }

  @override
  ValueStream<Map<String, PortValue>> getPortX() => _portValueByNameX;

  @override
  void setPortValue({required String name, required PortValue portValue}) {
    portValueByName = portValueByName.copy()..set(name, portValue);
  }

  @override
  Future<PortSubmitResult<Map<String, dynamic>>> submit() async {
    var hasError = false;
    for (final portValueByNameEntry in portValueByName.entries) {
      final name = portValueByNameEntry.key;
      final portValue = portValueByNameEntry.value;

      final error = await portValue.validate(portValue.value);
      setPortValue(name: name, portValue: portValue.copyWithError(error));

      if (error != null) {
        hasError = true;
      }
    }

    if (hasError) {
      return PortSubmitResult(data: null);
    }

    final submitValueByNameEntries = await Future.wait(portValueByName
        .mapToIterable((name, portValue) async => MapEntry(name, await portValue.submit(portValue.getOrNull()))));
    return PortSubmitResult(data: submitValueByNameEntries.toMap());
  }
}

abstract class PortWrapper<T> implements Port<T> {
  Port<T> get port;
}

mixin IsPortWrapper<T> implements PortWrapper<T> {
  @override
  ValueStream<Map<String, PortValue>> getPortX() => port.getPortX();

  @override
  void setPortValue({required String name, required PortValue portValue}) =>
      port.setPortValue(name: name, portValue: portValue);

  @override
  Future<PortSubmitResult<T>> submit() => port.submit();
}
