import '../../jlogical_utils.dart';

extension IterableModelExtensions<T> on Iterable<AsyncLoadable<T>> {
  /// Combines the list of models into one mapped model.
  /// If any of the parent models are in their initial state, this model will be in an initial state.
  /// If any of the parent models are in their error state, this model will be in an error state.
  CombinedLatestModel<T, R> combineLatest<R>(R mapper(Iterable<T> values)) {
    return CombinedLatestModel(parents: this, mapper: mapper);
  }
}
