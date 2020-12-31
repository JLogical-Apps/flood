import 'package:equatable/equatable.dart';

/// Stores two elements.
class Pair<A, B> extends Equatable {
  final A first;
  final B second;

  const Pair(this.first, this.second);

  @override
  List<Object> get props => [first, second];
}
