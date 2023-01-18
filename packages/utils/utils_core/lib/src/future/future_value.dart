import 'package:equatable/equatable.dart';

abstract class FutureValue<T> {
  static EmptyFutureValue<T> empty<T>() => EmptyFutureValue();

  static LoadingFutureValue<T> loading<T>() => LoadingFutureValue();

  static LoadedFutureValue<T> loaded<T>(T data) => LoadedFutureValue(data: data);

  static ErrorFutureValue<T> error<T>(dynamic error, StackTrace stackTrace) =>
      ErrorFutureValue(error: error, stackTrace: stackTrace);
}

extension FutureValueExtensions<T> on FutureValue<T> {
  bool get isEmpty => this is EmptyFutureValue;

  bool get isLoading => this is LoadingFutureValue;

  bool get isLoaded => this is LoadedFutureValue;

  bool get isError => this is ErrorFutureValue;

  T? getOrNull() {
    if (this is LoadedFutureValue) {
      return (this as LoadedFutureValue).data;
    }
    return null;
  }

  FutureValue<R> map<R>(R Function(T value) mapper) {
    if (this is EmptyFutureValue) {
      return EmptyFutureValue();
    }
    if (this is LoadingFutureValue) {
      return LoadingFutureValue();
    }
    if (this is LoadedFutureValue<T>) {
      return LoadedFutureValue(data: mapper((this as LoadedFutureValue<T>).data));
    }
    if (this is ErrorFutureValue<T>) {
      final errorState = this as ErrorFutureValue<T>;
      return ErrorFutureValue(error: errorState.error, stackTrace: errorState.stackTrace);
    }

    throw UnimplementedError();
  }

  Future<FutureValue<R>> asyncMap<R>(Future<R> Function(T value) asyncMapper) async {
    if (this is EmptyFutureValue) {
      return EmptyFutureValue();
    }
    if (this is LoadingFutureValue) {
      return LoadingFutureValue();
    }
    if (this is LoadedFutureValue<T>) {
      return LoadedFutureValue(data: await asyncMapper((this as LoadedFutureValue<T>).data));
    }
    if (this is ErrorFutureValue<T>) {
      final errorState = this as ErrorFutureValue<T>;
      return ErrorFutureValue(error: errorState.error, stackTrace: errorState.stackTrace);
    }

    throw UnimplementedError();
  }

  R when<R>({
    required R Function() onEmpty,
    required R Function() onLoading,
    required R Function(T value) onLoaded,
    required R Function(dynamic error, StackTrace stackTrace) onError,
  }) {
    if (this is EmptyFutureValue) {
      return onEmpty();
    }
    if (this is LoadingFutureValue) {
      return onLoading();
    }
    if (this is LoadedFutureValue<T>) {
      return onLoaded((this as LoadedFutureValue<T>).data);
    }
    if (this is ErrorFutureValue<T>) {
      final errorState = this as ErrorFutureValue<T>;
      return onError(errorState.error, errorState.stackTrace);
    }

    throw UnimplementedError();
  }

  R maybeWhen<R>({
    R Function()? onEmpty,
    R Function()? onLoading,
    R Function(T value)? onLoaded,
    R Function(dynamic error, StackTrace stackTrace)? onError,
    required R Function() orElse,
  }) {
    return when(
      onEmpty: onEmpty ?? orElse,
      onLoading: onLoading ?? orElse,
      onLoaded: (data) => onLoaded != null ? onLoaded(data) : orElse(),
      onError: (error, stackTrace) => onError != null ? onError(error, stackTrace) : orElse(),
    );
  }
}

class EmptyFutureValue<T> with EquatableMixin implements FutureValue<T> {
  @override
  List<Object?> get props => [];
}

class LoadingFutureValue<T> with EquatableMixin implements FutureValue<T> {
  @override
  List<Object?> get props => [];
}

class LoadedFutureValue<T> with EquatableMixin implements FutureValue<T> {
  final T data;

  LoadedFutureValue({required this.data});

  @override
  List<Object?> get props => [data];
}

class ErrorFutureValue<T> with EquatableMixin implements FutureValue<T> {
  final dynamic error;
  final StackTrace stackTrace;

  ErrorFutureValue({required this.error, required this.stackTrace});

  @override
  List<Object?> get props => [error, stackTrace];
}
