import 'dart:async';

import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import 'async_loadable.dart';
import 'future_value.dart';

/// An async loadable whose value and loader is based on another async loadable.
/// [T] is the type of the parent.
/// [R] is the type of this mapped model.
class MappedModel<T, R> extends AsyncLoadable<R> {
  /// Loading this model simply loads the parent.
  @override
  FutureOr<R> Function() get loader => () async => mapper((await parent.load()).get());

  /// This model gets its value stream from its parent.
  @override
  late final ValueStream<FutureValue<R>> valueX = parent.valueX.mapWithValue((value) => value.mapIfPresent(mapper));

  /// The current value.
  FutureValue<R> get value => parent.value.mapIfPresent(mapper);

  final AsyncLoadable<T> parent;
  final R Function(T value) mapper;

  MappedModel({required this.parent, required this.mapper}) {
    hasStartedLoading = parent.hasStartedLoading;
  }
}