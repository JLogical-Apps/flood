import 'dart:async';

import 'package:jlogical_utils/src/port/model/port_component.dart';

abstract class PortValueComponent<V> extends PortComponent {
  String get name;

  dynamic get initialValue;

  /// Converts the [rawValue] of the component into its value [V] type.
  V valueParser(dynamic rawValue) {
    if (rawValue is V) {
      return rawValue;
    }

    throw Exception('Cannot get [$V] from [$rawValue].');
  }

  /// Maps [value] to the value that should be in the final port results.
  FutureOr submitMapper(V value) => _defaultSubmitMapper(value);
}

V _defaultSubmitMapper<V>(V value) => value;
