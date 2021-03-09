import 'dart:ffi';

import 'package:equatable/equatable.dart';

/// Stores two elements.
class Pair<A extends Object, B extends Object> extends Equatable {
  final A first;
  final B second;

  const Pair(this.first, this.second);

  @override
  List<Object> get props => [first, second];
}
