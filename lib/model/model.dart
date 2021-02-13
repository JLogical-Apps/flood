import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';

@freezed
abstract class Model<T> with _$Model<T> {
  const factory Model.initial() = _InitialModel<T>;

  const factory Model.loaded({T model, bool isLoading}) = _LoadedModel<T>;

  const factory Model.error({dynamic error}) = _ErrorModel<T>;
}
