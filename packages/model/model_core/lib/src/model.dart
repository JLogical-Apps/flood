import 'dart:async';

import 'package:model_core/model_core.dart';
import 'package:model_core/src/model_mapper.dart';
import 'package:model_core/src/model_state.dart';
import 'package:rxdart/rxdart.dart';

abstract class Model<T> {
  ValueStream<ModelState<T>> get statesX;

  Future<void> onLoad();

  bool get hasStartedLoading;

  factory Model({required FutureOr<T> Function() loader}) => _ModelImpl(loader: loader);
}

extension ModelExtensions<T> on Model<T> {
  ModelState<T> get state => statesX.value;

  Future<void> load() async {
    await onLoad();
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
}

mixin IsModel<T> implements Model<T> {}

class _ModelImpl<T> with IsModel<T> {
  final FutureOr<T> Function() loader;

  @override
  bool hasStartedLoading = false;

  final BehaviorSubject<ModelState<T>> _statesSubject = BehaviorSubject.seeded(ModelState.empty<T>());

  @override
  ValueStream<ModelState<T>> get statesX => _statesSubject;

  _ModelImpl({required this.loader});

  @override
  Future<void> onLoad() async {
    hasStartedLoading = true;

    if (state.isEmpty || state.isError) {
      _statesSubject.value = ModelState.loading();
    }

    try {
      final data = await loader();
      _statesSubject.value = ModelState.loaded(data);
    } catch (e, stacktrace) {
      _statesSubject.value = ModelState.error(e, stacktrace);
    }
  }
}

abstract class ModelWrapper<T> implements Model<T> {
  Model<T> get model;
}

mixin IsModelWrapper<T> implements ModelWrapper<T> {
  @override
  ValueStream<ModelState<T>> get statesX => model.statesX;

  @override
  Future<void> onLoad() => model.onLoad();

  @override
  bool get hasStartedLoading => model.hasStartedLoading;
}
