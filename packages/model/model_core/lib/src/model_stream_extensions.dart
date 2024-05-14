import 'package:model_core/src/model.dart';
import 'package:utils_core/utils_core.dart';

extension ModelStreamExtensions<T> on Stream<T> {
  Model<T> asModel({FutureValue<T>? initialValue}) => Model.fromValueStream(asValueStream(initialValue: initialValue));
}
