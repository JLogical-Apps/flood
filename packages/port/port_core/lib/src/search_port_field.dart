import 'dart:async';

import 'package:port_core/src/port_field.dart';

class SearchPortField<R, T> with IsPortFieldWrapper<T, T> {
  @override
  final PortField<T, T> portField;

  final FutureOr<List<R>> Function() search;

  final T Function(R result) valueMapper;
  final R? Function(T value, List<R> results) resultsMapper;

  SearchPortField({
    required this.portField,
    required this.search,
    required this.valueMapper,
    required this.resultsMapper,
  });

  @override
  PortField<T, T> copyWith({required T value, required error}) {
    return SearchPortField(
      portField: portField.copyWith(value: value, error: error),
      search: search,
      valueMapper: valueMapper,
      resultsMapper: resultsMapper,
    );
  }

  T getValue(R result) {
    return valueMapper(result);
  }

  R? getResult(T value, List<R> results) {
    return resultsMapper(value, results);
  }
}
