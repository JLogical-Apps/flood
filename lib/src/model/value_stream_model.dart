import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'async_loadable.dart';
import 'future_value.dart';

/// A model that is has a root stream, but can be reloaded using a [loader].
class ValueStreamModel<T> extends AsyncLoadable<T> {
  @override
  final ValueStream<FutureValue<T>> valueX;

  @override
  final FutureOr<T> Function() loader;

  ValueStreamModel({required this.valueX, required this.loader, bool hasStartedLoading: false}) {
    this.hasStartedLoading = hasStartedLoading;
  }
}
