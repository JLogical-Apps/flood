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

  ModelState<R> map<R>(R Function(T value) mapper) {
    if (this is EmptyModelState) {
      return EmptyModelState();
    }
    if (this is LoadingModelState) {
      return LoadingModelState();
    }
    if (this is LoadedModelState<T>) {
      return LoadedModelState(data: mapper((this as LoadedModelState<T>).data));
    }
    if (this is ErrorModelState<T>) {
      final errorState = this as ErrorModelState<T>;
      return ErrorModelState(error: errorState.error, stacktrace: errorState.stacktrace);
    }

    throw UnimplementedError();
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
