import 'model.dart';

/// A store for all the models of a particular type.
class ModelStore<T> {
  /// Maps the model id to its model.
  final Map<String, Model<T>> _models;

  ModelStore() : _models = Map();

  /// Returns the model of the entity with the given [id].
  /// If no model exists, it uses [onCreate] to generate a new one.
  Model<T> get(String id, Model<T> onCreate()) {
    var model = _models[id];
    if (model == null) {
      model = onCreate();
      _models[id] = model;
    }
    return model;
  }
}
