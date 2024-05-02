import 'package:flutter/material.dart';

abstract class StyledSearchResultOverride<T> {
  Widget build(T result);

  bool passes(dynamic result);

  factory StyledSearchResultOverride({
    required Widget Function(T result) resultBuilder,
  }) =>
      _StyledSearchResultOverride(
        resultBuilder: resultBuilder,
      );
}

mixin IsStyledSearchResultOverride<T> implements StyledSearchResultOverride<T> {
  @override
  bool passes(result) {
    return result is T;
  }
}

class _StyledSearchResultOverride<T> with IsStyledSearchResultOverride<T> {
  final Widget Function(T result) resultBuilder;

  _StyledSearchResultOverride({required this.resultBuilder});

  @override
  Widget build(T result) {
    return resultBuilder(result);
  }
}
