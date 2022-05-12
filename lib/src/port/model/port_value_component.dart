import 'dart:async';

import 'package:jlogical_utils/src/port/model/port_component.dart';

abstract class PortValueComponent<V> extends PortComponent {
  String get name;

  V get initialValue;

  /// Maps [value] to the value that should be in the final port results.
  FutureOr submitMapper(V value) => _defaultSubmitMapper(value);
}

V _defaultSubmitMapper<V>(V value) => value;
