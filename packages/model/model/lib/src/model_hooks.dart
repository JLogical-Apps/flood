import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model_core/model_core.dart';
import 'package:utils/utils.dart';

FutureValue<T>? useModelOrNull<T>(Model<T>? model) {
  useEffect(
    () {
      model?.loadIfNotStarted();
      return null;
    },
    [model],
  );
  useStream(model?.stateX);
  return model?.stateX.value;
}

FutureValue<T> useModel<T>(Model<T> model) {
  return useModelOrNull(model)!;
}

List<FutureValue<T>> useModels<T>(List<Model<T>> models) {
  return useValueStreams(models.map((model) => model.stateX).toList());
}

Model<T> useFutureModel<T>(
  Future<T> Function() futureGetter, [
  List<Object?> keys = const <Object>[],
]) {
  final model = useMemoized(() => Model(loader: futureGetter)..load(), keys);
  useModel(model);
  return model;
}
