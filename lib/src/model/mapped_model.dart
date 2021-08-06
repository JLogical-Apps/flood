import 'dart:async';

import 'package:jlogical_utils/src/model/async_loadable.dart';
import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:rxdart/src/streams/value_stream.dart';

/// An async loadable whose value and loader is based on another async loadable.
class MappedModel<T> extends AsyncLoadable<T> {
  @override
  final FutureOr<T> Function() loader;

  @override
  final ValueStream<FutureValue<T>> valueX;

  MappedModel({required this.loader, required this.valueX});
}
