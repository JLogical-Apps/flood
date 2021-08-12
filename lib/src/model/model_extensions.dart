import 'package:jlogical_utils/src/model/switch_map_model.dart';

import '../../jlogical_utils.dart';

extension IterableModelExtensions<T> on Iterable<AsyncLoadable<T>> {
  /// Combines the list of models into one mapped model.
  /// If any of the parent models are in their initial state, this model will be in an initial state.
  /// If any of the parent models are in their error state, this model will be in an error state.
  CombinedLatestModel<T, R> combineLatest<R>(R mapper(Iterable<T> values)) {
    return CombinedLatestModel(parents: this, mapper: mapper);
  }
}

extension ModelExtensions<T> on AsyncLoadable<T> {
  /// Maps this to another model.
  /// Whenever this model's value changes, the switch-mapped model stops listening to the old model
  /// and starts listening to the new model from [mapper].
  SwitchMapModel<T, R> switchMap<R>(AsyncLoadable<R> mapper(T value)) {
    return SwitchMapModel(parent: this, mapper: mapper);
  }
}
