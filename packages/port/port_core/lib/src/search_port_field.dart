import 'dart:async';

import 'package:port_core/src/port_field.dart';
import 'package:rxdart/streams.dart';
import 'package:utils_core/utils_core.dart';

class SearchPortField<R, T> with IsPortFieldWrapper<T, T> {
  @override
  final PortField<T, T> portField;

  final FutureOr<ValueStream<FutureValue<List<R>>>> Function() searchX;

  final T Function(R result) valueMapper;
  final R? Function(T value, List<R> results) resultsMapper;

  SearchPortField({
    required this.portField,
    required this.searchX,
    required this.valueMapper,
    required this.resultsMapper,
  });

  @override
  PortField<T, T> copyWith({required T value, required error}) {
    return SearchPortField(
      portField: portField.copyWith(value: value, error: error),
      searchX: searchX,
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
