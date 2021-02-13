import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';

/// A model that stores data that is retrieved in a future.
@freezed
abstract class Model<T> with _$Model<T> {
  const factory Model.initial() = ModelInitial<T>;

  const factory Model.loaded({T model, bool isLoading}) = ModelLoaded<T>;

  const factory Model.error({dynamic error}) = ModelError<T>;

  /// Invokes the future and returns the result of it in a loaded model.
  /// If an exception occurred, returns an error model.
  static Future<Model<T>> guard<T>(Future<T> future()) async {
    try {
      var data = await future();
      return Model.loaded(model: data, isLoading: false);
    } catch (ex) {
      return Model.error(error: ex);
    }
  }
}
