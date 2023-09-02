import 'dart:async';

import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class AsyncMapModel<T, R> with IsModel<R> {
  final Model<T> model;
  final Future<R> Function(T source) mapper;

  final BehaviorSubject<FutureValue<R>> valueSubject;
  StreamSubscription? subscription;

  AsyncMapModel({required this.model, required this.mapper})
      : valueSubject = BehaviorSubject.seeded(model.state.when(
          onEmpty: () => FutureValue.empty(),
          onLoading: () => FutureValue.loading(),
          onLoaded: (data) => FutureValue.loading(),
          onError: (error, stackTrace) => FutureValue.error(error, stackTrace),
        )) {
    valueSubject.onListen = () {
      subscription =
          model.stateX.asyncMap((data) => data.asyncMap(mapper)).listen((state) => valueSubject.value = state);
    };
    valueSubject.onCancel = () {
      subscription?.cancel();
      subscription = null;
    };
  }

  @override
  late ValueStream<FutureValue<R>> stateX = valueSubject;

  @override
  Future<void> onLoad() async {
    if (subscription == null && (state.isEmpty || state.isError)) {
      valueSubject.value = FutureValue.loading();
    }
    final loadedState = await model.load();

    if (subscription == null) {
      final mappedState = await loadedState.asyncMap(mapper);
      valueSubject.value = mappedState;
    }
  }
}
