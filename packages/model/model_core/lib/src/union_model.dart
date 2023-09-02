import 'dart:async';

import 'package:collection/collection.dart';
import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class UnionModel with IsModel<List> {
  final List<Model> models;

  UnionModel({required this.models});

  @override
  Future<void> onLoad() async {
    await Future.wait(models.map((model) => model.load()));

    // Allow enough time for the combinedLatestWithValue to refresh its value.
    await Future.delayed(Duration(milliseconds: 1));
  }

  @override
  late final ValueStream<FutureValue<List>> stateX =
      models.map((model) => model.stateX).toList().combineLatestWithValue((states) {
    final errorState = states.firstWhereOrNull((state) => state is ErrorFutureValue) as ErrorFutureValue?;
    if (errorState != null) {
      return FutureValue.error(errorState.error, errorState.stackTrace);
    }

    if (states.any((state) => state.isEmpty)) {
      return FutureValue.empty();
    }

    if (states.any((state) => state.isLoading)) {
      return FutureValue.loading();
    }

    final loadedValues = states.cast<LoadedFutureValue>().map((state) => state.data).toList();
    return FutureValue.loaded(loadedValues);
  });
}
