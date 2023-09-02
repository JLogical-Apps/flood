import 'dart:async';

import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class ValueStreamModel<T> with IsModel<T> {
  @override
  final ValueStream<FutureValue<T>> stateX;

  final FutureOr Function()? loader;

  ValueStreamModel({required this.stateX, this.loader});

  @override
  Future<void> onLoad() async {
    await loader?.call();
  }
}
