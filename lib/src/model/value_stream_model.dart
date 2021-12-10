import 'dart:async';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:rxdart/rxdart.dart';

/// A model that is has a root stream, but can be reloaded using a [loader].
class ValueStreamModel<T> extends AsyncLoadable<T> {
  @override
  final ValueStream<FutureValue<T>> valueX;

  @override
  final FutureOr<T> Function() loader;

  ValueStreamModel({required this.valueX, required this.loader});
}
