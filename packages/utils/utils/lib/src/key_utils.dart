import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class EquatableKey<T> extends LocalKey with EquatableMixin {
  final T value;

  EquatableKey(this.value);

  @override
  List<Object?> get props => [value];
}
