import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

abstract class MultiModelState<M> extends Equatable {
  @override
  List<Object> get props => [];
}

class MultiInitialState<M> extends MultiModelState<M> {}

class MultiLoadedState<M> extends MultiModelState<M> {
  /// Maps the ids to their models.
  final Map<String, M> idToModelMap;

  /// Whether more elements are being loaded.
  final bool isLoading;

  /// Whether more elements can be loaded.
  final bool canLoadMore;

  /// The loaded ids.
  List<String> get ids => idToModelMap.keys.toList();

  /// The loaded models.
  List<M> get models => idToModelMap.values.toList();

  MultiLoadedState({@required this.idToModelMap, @required this.isLoading, @required this.canLoadMore});

  @override
  List<Object> get props => [idToModelMap, isLoading, canLoadMore];
}

class MultiErrorState<M> extends MultiModelState<M> {
  final dynamic error;

  MultiErrorState({this.error});

  @override
  List<Object> get props => [error];
}
