import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../jlogical_utils.dart';

part 'model.g.dart';

class Model<T> = ModelBase<T> with _$Model<T>;

abstract class ModelBase<T> with Store {
  /// The value of the model.
  @observable
  FutureValue<T> value;

  /// A function that loads data to be stored in the model.
  final FutureOr<T> Function() loader;

  ModelBase({this.loader});

  /// Loads the data for the model using the [loader].
  @action
  Future<void> load() async {
    if(value is FutureValueError){
      value = FutureValue.initial();
    }

    value = await FutureValue.guard(() async => await loader());
  }

  /// Sets the value of the model.
  @action
  void set(T _value) {
    value = FutureValue.loaded(value: _value);
  }
}
