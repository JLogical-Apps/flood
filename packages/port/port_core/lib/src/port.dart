import 'dart:async';

import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/port_field_provider.dart';
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

  PortFieldProvider getPortFieldProvider() {
    return PortFieldProvider(
      fieldGetter: (name) => portFieldByName[name],
      portFieldSetter: (name, portField) => setPortField(name: name, portField: portField),
    );
  }

  PortField? getFieldByPathOrNull(String path) {
    if (path.isEmpty) {
      return null;
    }

    final segments = path.split('/');
    PortFieldProvider portFieldProvider = getPortFieldProvider();
    PortField? portField;

    for (var i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final isLast = (i + 1) == segments.length;

      final newPortField = portFieldProvider.getFieldByNameOrNull(segment);
      if (newPortField == null) {
        return null;
      }

      portField = newPortField;
      if (!isLast) {
        final newPortFieldProvider = portField.getPortFieldProviderOrNull();
        if (newPortFieldProvider == null) {
          return null;
        }
        portFieldProvider = newPortFieldProvider;
      }
    }

    return portField;
  }

  PortField getFieldByPath(String path) {
    if (path.isEmpty) {
      return portFieldByName[path] ?? (throw Exception('Could not find port field with name [$path]'));
    }

    final segments = path.split('/');
    PortFieldProvider portFieldProvider = getPortFieldProvider();
    late PortField portField;

    for (var i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final isLast = (i + 1) == segments.length;

      portField = portFieldProvider.getFieldByNameOrNull(segment) ??
          (throw Exception('Could not find port field with segment [$segment] in path [$path]'));

      if (!isLast) {
        portFieldProvider = portField.getPortFieldProviderOrNull() ??
            (throw Exception('Could not find port field provider with segment [$segment] in path [$path]'));
      }
    }

    return portField;
  }

  void setPortFieldForPath({required String path, required PortField portField}) {
    final segments = path.split('/');
    PortFieldProvider portFieldProvider = getPortFieldProvider();
    late PortField nestedPortField;

    for (var i = 0; i < segments.length - 1; i++) {
      final segment = segments[i];

      nestedPortField = portFieldProvider.getFieldByNameOrNull(segment) ??
          (throw Exception('Could not find port field with segment [$segment] in path [$path]'));

      portFieldProvider = nestedPortField.getPortFieldProviderOrNull() ??
          (throw Exception('Could not find port field provider with segment [$segment] in path [$path]'));
    }

    portFieldProvider.setFieldByName(name: segments.last, portField: portField);
  }

  F? getByPathOrNull<F>(String path) => getFieldByPathOrNull(path)?.value;

  F getByPath<F>(String path) => getFieldByPath(path).value;

  dynamic getErrorByPathOrNull(String path) => getFieldByPathOrNull(path)?.error;

  dynamic getErrorByPath(String path) => getFieldByPath(path).error;

  void setValue({required String path, required dynamic value}) {
    final field = getFieldByPath(path);
    final parsedValue = field.parseValue(value);
    setPortFieldForPath(
      path: path,
      portField: field.copyWithValue(parsedValue),
    );
  }

  void setError({required String path, required dynamic error}) => setPortFieldForPath(
        path: path,
        portField: getFieldByPath(path).copyWithError(error),
      );

  void clearError({required String path}) => setError(path: path, error: null);

  dynamic operator [](String path) => getByPath(path);

  operator []=(String path, dynamic value) => setValue(path: path, value: value);

  PortMapper<T, R> map<R>(FutureOr<R?> Function(T sourceData, Port<T> port) mapper, {Type? submitType}) {
    return PortMapper(port: this, mapper: mapper, submitType: submitType);
  }
}

mixin IsPort<T> implements Port<T> {}

class _PortImpl with IsPort<Map<String, dynamic>> {
  final BehaviorSubject<Map<String, PortField>> _portFieldByNameX;

  _PortImpl(Map<String, PortField> valueByName) : _portFieldByNameX = BehaviorSubject.seeded(valueByName) {
    for (final (fieldName, portField) in valueByName.entryRecords) {
      portField.registerToPort(fieldName, this);
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
