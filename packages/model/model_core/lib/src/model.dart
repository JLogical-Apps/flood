import 'dart:async';

import 'package:model_core/src/model_async_mapper.dart';
import 'package:model_core/src/model_mapper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class Model<T> {
  ValueStream<FutureValue<T>> get statesX;

  Future<void> onLoad();

  bool get hasStartedLoading;

  factory Model({required FutureOr<T> Function() loader}) => _ModelImpl(loader: loader);
}

extension ModelExtensions<T> on Model<T> {
  FutureValue<T> get state => statesX.value;

  Future<FutureValue<T>> load() async {
    await onLoad();
    return state;
  }

  Future<void> loadIfNotStarted() async {
    if (hasStartedLoading) {
      return;
    }

    await load();
  }

  T? getOrNull() => state.getOrNull();

  Model<R> map<R>(R Function(T value) mapper) {
    return ModelMapper(model: this, mapper: mapper);
  }

  Model<R> asyncMap<R>(Future<R> Function(T value) asyncMapper) {
    return ModelAsyncMapper(model: this, mapper: asyncMapper);
  }
}

mixin IsModel<T> implements Model<T> {}

class _ModelImpl<T> with IsModel<T> {
  final FutureOr<T> Function() loader;

  @override
  bool hasStartedLoading = false;

  final BehaviorSubject<FutureValue<T>> _statesSubject = BehaviorSubject.seeded(FutureValue.empty<T>());

  @override
  ValueStream<FutureValue<T>> get statesX => _statesSubject;

  _ModelImpl({required this.loader});

  @override
  Future<void> onLoad() async {
    hasStartedLoading = true;

    if (state.isEmpty || state.isError) {
      _statesSubject.value = FutureValue.loading();
    }

    try {
      final data = await loader();
      _statesSubject.value = FutureValue.loaded(data);
    } catch (e, stacktrace) {
      _statesSubject.value = FutureValue.error(e, stacktrace);
    }
  }
}

abstract class ModelWrapper<T> implements Model<T> {
  Model<T> get model;
}

mixin IsModelWrapper<T> implements ModelWrapper<T> {
  @override
  ValueStream<FutureValue<T>> get statesX => model.statesX;

  @override
  Future<void> onLoad() => model.onLoad();

  @override
  bool get hasStartedLoading => model.hasStartedLoading;
}
