import 'dart:async';

import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class MapModel<T, R> with IsModel<R> {
  final Model<T> model;
  final R Function(T source) mapper;

  MapModel({required this.model, required this.mapper});

  @override
  Future<void> onLoad() => model.onLoad();

  @override
  late final ValueStream<FutureValue<R>> stateX = model.stateX.mapWithValue((state) => state.map(mapper));
}
