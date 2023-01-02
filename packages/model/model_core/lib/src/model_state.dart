abstract class ModelState<T> {
  static EmptyModelState<T> empty<T>() => EmptyModelState();

  static LoadingModelState<T> loading<T>() => LoadingModelState();

  static LoadedModelState<T> loaded<T>(T data) => LoadedModelState(data: data);

  static ErrorModelState<T> error<T>(dynamic error, StackTrace stacktrace) =>
      ErrorModelState(error: error, stacktrace: stacktrace);
}

extension ModelStateExtensions<T> on ModelState<T> {
  bool get isEmpty => this is EmptyModelState;

  bool get isLoading => this is LoadingModelState;

  bool get isLoaded => this is LoadedModelState;

  bool get isError => this is ErrorModelState;

  T? getOrNull() {
    if (this is LoadedModelState) {
      return (this as LoadedModelState).data;
    }
    return null;
  }
}

class EmptyModelState<T> implements ModelState<T> {}

class LoadingModelState<T> implements ModelState<T> {}

class LoadedModelState<T> implements ModelState<T> {
  final T data;

  LoadedModelState({required this.data});
}

class ErrorModelState<T> implements ModelState<T> {
  final dynamic error;
  final StackTrace stacktrace;

  ErrorModelState({required this.error, required this.stacktrace});
}
