import 'dart:async';

import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class ModelAsyncMapper<T, R> with IsModel<R> {
  final Model<T> model;
  final Future<R> Function(T source) mapper;

  ModelAsyncMapper({required this.model, required this.mapper});

  @override
  bool get hasStartedLoading => model.hasStartedLoading;

  @override
  Future<void> onLoad() async {
    return model.onLoad();
  }

  @override
  late final ValueStream<FutureValue<R>> statesX = model.statesX.asyncMapWithValue(
    (state) => state.asyncMap(mapper),
    initialValue: model.state.when(
      onEmpty: () => FutureValue.empty(),
      onLoading: () => FutureValue.loading(),
      onLoaded: (data) => FutureValue.loading(),
      onError: (error, stackTrace) => FutureValue.error(error, stackTrace),
    ),
  );
}
