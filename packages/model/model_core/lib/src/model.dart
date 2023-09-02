import 'dart:async';

import 'package:model_core/src/async_map_model.dart';
import 'package:model_core/src/flat_map_model.dart';
import 'package:model_core/src/map_model.dart';
import 'package:model_core/src/union_model.dart';
import 'package:model_core/src/value_stream_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class Model<T> {
  ValueStream<FutureValue<T>> get stateX;

  Future<void> onLoad();

  factory Model({required FutureOr<T> Function() loader}) => _ModelImpl(loader: loader);

  factory Model.value(T value) => _ModelImpl(loader: () => value);

  factory Model.fromValueStream(
    ValueStream<FutureValue<T>> stateX, {
    FutureOr Function()? onLoad,
  }) =>
      ValueStreamModel(
        stateX: stateX,
        loader: onLoad,
      );

  static Model<List> union(List<Model> models) {
    return UnionModel(models: models);
  }
}

extension ModelExtensions<T> on Model<T> {
  FutureValue<T> get state => stateX.value;

  Future<FutureValue<T>> load() async {
    await onLoad();
    return state;
  }

  Future<void> loadIfNotStarted() async {
    if (state.isEmpty) {
      await load();
    }
  }

  T? getOrNull() => state.getOrNull();

  Future<T> getOrLoad() async {
    if (!state.isLoaded) {
      await load();
    }

    if (state.isError) {
      throw (state as ErrorFutureValue<T>).error;
    }

    return state.as<LoadedFutureValue<T>>()?.data ?? (throw Exception('Could not load this model! Value is: [$state]'));
  }

  Model<R> map<R>(R Function(T value) mapper) {
    return MapModel(model: this, mapper: mapper);
  }

  Model<R> asyncMap<R>(Future<R> Function(T value) asyncMapper) {
    return AsyncMapModel(model: this, mapper: asyncMapper);
  }

  Model<R> flatMap<R>(Model<R> Function(T value) mapper) {
    return FlatMapModel(model: this, mapper: mapper);
  }
}

mixin IsModel<T> implements Model<T> {}

class _ModelImpl<T> with IsModel<T> {
  final FutureOr<T> Function() loader;

  final BehaviorSubject<FutureValue<T>> _statesSubject = BehaviorSubject.seeded(FutureValue.empty<T>());

  @override
  ValueStream<FutureValue<T>> get stateX => _statesSubject;

  _ModelImpl({required this.loader});

  @override
  Future<void> onLoad() async {
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
  ValueStream<FutureValue<T>> get stateX => model.stateX;

  @override
  Future<void> onLoad() => model.onLoad();
}
