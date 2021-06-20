import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:rxdart/rxdart.dart';

/// A model that is mapped from another model.
class MappedModel<T, R> extends Modelable<R>{

  /// The model to map the values from.
  final Modelable<T> parentModel;

  /// Maps the values from the parent model to this model.
  final R Function(T value) mapper;

  MappedModel({required this.parentModel, required this.mapper});

  @override
  Future<void> load() {
    return parentModel.load();
  }

  @override
  ValueStream<FutureValue<R>> get valueX {
    var initialValue = parentModel.value.mapIfPresent(mapper);
    var stream = parentModel.valueX.map((futureValue) => futureValue.mapIfPresent(mapper));

    return stream.shareValueSeeded(initialValue);
  }

}