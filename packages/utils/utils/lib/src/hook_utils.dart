import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils/utils.dart';

/// Returns a Value that can be used to get and set values without rebuilding the widget.
Value<T> useMutable<T>(T Function() defaultValue) {
  final list = useMemoized(() => <T>[defaultValue()]);
  return Value(
    valueGetter: () => list[0],
    valueSetter: (value) => list[0] = value,
  );
}

class Value<T> {
  final T Function() valueGetter;
  final void Function(T value) valueSetter;

  Value({required this.valueGetter, required this.valueSetter});

  T get value => valueGetter();

  set value(T value) => valueSetter(value);
}

AsyncSnapshot<T> useMemoizedFuture<T>(Future<T> Function() future) {
  return useFuture(useMemoized(future));
}

T useValueStream<T>(ValueStream<T> valueStream) {
  useStream(valueStream);
  return valueStream.value;
}

T? useValueStreamOrNull<T>(ValueStream<T>? valueStream) {
  useStream(valueStream);
  return valueStream?.value;
}

List<T> useValueStreams<T>(List<ValueStream<T>> valueStreams) {
  final combinedStream = useMemoized(() => valueStreams.combineLatestWithValue((s) => s), valueStreams);
  useStream(combinedStream);
  return combinedStream.value.toList();
}

void useListen<T>(Stream<T> stream, [Function(T? value)? valueChanged]) {
  useEffect(
    () {
      final subscription = stream.listen((event) => valueChanged?.call(event));
      return () => subscription.cancel();
    },
    [stream],
  );
}

void useOneTimeEffect(void Function()? Function() effect) {
  useEffect(effect, [0]);
}
