import 'dart:async';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:mobx/mobx.dart';

part 'model_list.g.dart';

class ModelList<T> = ModelListBase<T> with _$ModelList<T>;

abstract class ModelListBase<T> with Store {
  /// The models in the list.
  @observable
  FutureValue<List<Model<T>>> models;

  /// A function that loads data to be stored in the model.
  FutureOr<Map<String, T>> Function() loader;

  /// Passed in converter that converts entities with ids into a model.
  Model<T> Function(String id, T entity) converter;

  ModelListBase({this.loader, this.converter});

  /// Loads the models using the loader.
  @action
  Future<void> load() async {
    if (models is FutureValueError) {
      models = FutureValue.initial();
    }

    models = await FutureValue.guard(() async => (await loader()).entries.map((entry) => converter(entry.key, entry.value)).toList());
  }
}
