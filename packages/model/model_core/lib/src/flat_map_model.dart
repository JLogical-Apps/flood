import 'dart:async';

import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class FlatMapModel<T, R> with IsModel<R> {
  final Model<T> model;
  final Model<R> Function(T source) mapper;

  FlatMapModel({required this.model, required this.mapper});

  @override
  Future<void> onLoad() async {
    final state = await model.load();
    final mappedModel = state.getOrNull()?.mapIfNonNull(mapper);
    if (mappedModel != null) {
      await mappedModel.load();
    }
  }

  @override
  late final ValueStream<FutureValue<R>> stateX = model.stateX.switchMapWithValue((state) {
    return state.when(
      onEmpty: () => BehaviorSubject.seeded(FutureValue.empty()),
      onLoading: () => BehaviorSubject.seeded(FutureValue.loading()),
      onLoaded: (value) {
        try {
          final mappedModel = mapper(value)..loadIfNotStarted();
          return mappedModel.stateX;
        } catch (e, stackTrace) {
          return BehaviorSubject.seeded(FutureValue.error(e, stackTrace));
        }
      },
      onError: (error, stackTrace) => BehaviorSubject.seeded(FutureValue.error(error, stackTrace)),
    );
  });
}
