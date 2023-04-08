import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model_core/model_core.dart';
import 'package:utils_core/utils_core.dart';

FutureValue<T>? useModelOrNull<T>(Model<T>? model) {
  useStream(model?.stateX);
  return model?.stateX.value;
}

FutureValue<T> useModel<T>(Model<T> model) {
  return useModelOrNull(model)!;
}

Model<T> useFutureModel<T>(
  Future<T> Function() futureGetter, [
  List<Object?> keys = const <Object>[],
]) {
  final model = useMemoized(() => Model(loader: futureGetter)..load(), keys);
  useModel(model);
  return model;
}
