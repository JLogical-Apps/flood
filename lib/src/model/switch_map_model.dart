import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../jlogical_utils.dart';

/// Maps a parent to another model.
/// Whenever the parent's value changes, this model stops listening to the old model
/// and starts listening to the new model.
class SwitchMapModel<T, R> extends AsyncLoadable<R> {
  /// Loading this model loads the parent and all derived models.
  @override
  FutureOr<R> Function() get loader => () async {
        await parent.load();
        _getValueFromParent(parent.value).maybeWhen(
          loaded: (childModel) => childModel.load(),
          orElse: () {},
        );
        return value.get();
      };

  @override
  late final ValueStream<FutureValue<R>> valueX = parent.valueX
      .switchMap<FutureValue<R>>((value) => _getValueFromParent(value).get().valueX)
      .publishValueSeeded(value)
      .autoConnect();

  /// The value from the parent.
  FutureValue<R> get value => _getValueFromParent(parent.value).mapIfPresent((value) => value.get());

  final AsyncLoadable<T> parent;
  final AsyncLoadable<R> Function(T value) mapper;

  SwitchMapModel({required this.parent, required this.mapper});

  FutureValue<AsyncLoadable<R>> _getValueFromParent(FutureValue<T> parentValue) {
    return parentValue.mapIfPresent((value) => mapper(value));
  }
}
