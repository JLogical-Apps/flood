import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model_core/model_core.dart';
import 'package:utils_core/utils_core.dart';

FutureValue<T> useModel<T>(Model<T> model) {
  useStream(model.statesX);
  return model.statesX.value;
}

Model<T> useFutureModel<T>(Future<T> Function() futureGetter) {
  final model = useMemoized(() => Model(loader: futureGetter)..load());
  useModel(model);
  return model;
}
