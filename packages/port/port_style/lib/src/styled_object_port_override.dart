import 'package:flutter/material.dart';
import 'package:port/port.dart';

abstract class StyledObjectPortOverride<T> {
  Widget build(Port port);

  Type get portType;

  factory StyledObjectPortOverride({
    required Widget Function(Port port) portBuilder,
  }) =>
      _StyledObjectPortOverride(
        portBuilder: portBuilder,
      );
}

mixin IsStyledObjectPortOverride<T> implements StyledObjectPortOverride<T> {
  @override
  Type get portType => T;
}

class _StyledObjectPortOverride<T> with IsStyledObjectPortOverride<T> {
  final Widget Function(Port port) portBuilder;

  _StyledObjectPortOverride({required this.portBuilder});

  @override
  Widget build(Port port) {
    return portBuilder(port);
  }
}
