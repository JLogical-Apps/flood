import 'dart:async';

import 'package:jlogical_utils/src/port/model/port_component.dart';

abstract class PortValueComponent<V> extends PortComponent {
  String get name;

  dynamic get initialValue;

  dynamic get initialFallback;

  /// Converts the [rawValue] of the component into its value [V] type.
  V valueParser(dynamic rawValue) {
    if (rawValue is V) {
      return rawValue;
    }

    throw Exception('Cannot get [$V] from [$rawValue].');
  }

  /// Maps [value] to the value that should be in the final port results.
  FutureOr submitMapper(V value) => _defaultSubmitMapper(value);

  dynamic get rawValue => port.getRaw(name);

  dynamic get fallback => port.getFallback(name);

  Object? get exception => port.getExceptionByName(name);

  V get value => getValue();

  V getValue({bool withFallback: true}) {
    var value = valueParser(rawValue);
    if (value == null && withFallback) {
      value = fallback;
    }

    return value;
  }
}

V _defaultSubmitMapper<V>(V value) => value;
