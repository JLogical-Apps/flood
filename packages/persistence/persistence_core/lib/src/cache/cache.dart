import 'dart:async';

import 'package:persistence_core/src/cache/cache_policy.dart';
import 'package:utils_core/utils_core.dart';

class Cache<T> {
  final CachePolicy cachePolicy;

  FutureOr<T> Function() sourceValueGetter;

  FutureValue<T> value;

  Cache(this.sourceValueGetter, {CachePolicy? cachePolicy, FutureValue<T>? initialValue})
      : cachePolicy = cachePolicy ?? CachePolicy.timed(Duration(minutes: 1)),
        value = initialValue ?? FutureValue.empty();

  Future<T> get() async {
    if (value.isEmpty || !cachePolicy.shouldUseCache()) {
      final sourceValue = await sourceValueGetter();
      cachePolicy.onRetrieveSource();
      value = FutureValue.loaded(sourceValue);
      return sourceValue;
    } else {
      return value.getOrNull() as T;
    }
  }

  void clear() {
    value = FutureValue.empty();
  }

  void set(T value) {
    this.value = FutureValue.loaded(value);
  }
}
