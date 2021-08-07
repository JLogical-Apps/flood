import 'dart:async';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:rxdart/rxdart.dart';

/// A model that is a combination of other models mapped into one.
/// If any of the parent models are in their initial state, this model will be in an initial state.
/// If any of the parent models are in their error state, this model will be in an error state.
class CombinedLatestModel<T, R> extends AsyncLoadable<R> {
  /// Loading this model simply loads the parents.
  @override
  FutureOr<R> Function() get loader => () async {
        final parentMaybeValues = await Future.wait(parents.map((asyncLoadable) => asyncLoadable.load()));
        final parentValues = parentMaybeValues.map((maybe) => maybe.get());
        return mapper(parentValues);
      };

  @override
  late final ValueStream<FutureValue<R>> valueX =
      parents.map((parent) => parent.valueX).combineLatestWithValue(_getValueFromParents);

  /// The value from the parents.
  FutureValue<R> get value => _getValueFromParents(parents.map((parent) => parent.value));

  final Iterable<AsyncLoadable<T>> parents;
  final R Function(Iterable<T> value) mapper;

  CombinedLatestModel({required this.parents, required this.mapper});

  FutureValue<R> _getValueFromParents(Iterable<FutureValue<T>> parentValues) {
    if (parentValues.any((maybe) => maybe is FutureValueInitial)) return FutureValue.initial();
    if (parentValues.any((maybe) => maybe is FutureValueError)) return FutureValue.error();
    return FutureValue.loaded(value: mapper(parentValues.map((maybe) => maybe.get())));
  }
}
