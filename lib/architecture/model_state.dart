import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ModelState<T> extends Equatable {
  const ModelState();

  @override
  List<Object> get props => [];
}

class ModelLoadingState<T> extends ModelState<T> {}

class ModelLoadedState<T> extends ModelState<T> {
  final T model;

  const ModelLoadedState({@required this.model});

  @override
  List<Object> get props => [model];
}
