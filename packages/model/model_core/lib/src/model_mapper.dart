import 'dart:async';

import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class ModelMapper<T, R> with IsModel<R> {
  final Model<T> model;
  final R Function(T source) mapper;

  ModelMapper({required this.model, required this.mapper});

  @override
  bool get hasStartedLoading => model.hasStartedLoading;

  @override
  Future<void> onLoad() => model.onLoad();

  @override
  late final ValueStream<FutureValue<R>> statesX = model.statesX.mapWithValue((state) => state.map(mapper));
}
