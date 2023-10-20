import 'dart:async';

extension IterableExtensions<T> on Iterable<T> {
  /// Returns the sum of the elements of the iterable based on a property of the items in the list.
  num sumBy(num Function(T element) f) {
    num sum = 0;
    for (var item in this) {
      sum += f(item);
    }
    return sum;
  }

  int sumByInt(int Function(T element) f) {
    int sum = 0;
    for (var item in this) {
      sum += f(item);
    }
    return sum;
  }

  /// Returns a copy of the iterable.
  /// Can provide an optional copier to copy the items in a specific way.
  List<T> copy([T Function(T value)? copier]) {
    if (copier == null) return List.of(this);

    return List.of(map(copier));
  }

  /// Safely maps the elements of this iterable into a new one.
  /// If a mapper throws an exception, it is not included in the map and calls [onError].
  Iterable<R> tryMap<R>(R Function(T value) mapper, {void Function(T value, dynamic error)? onError}) {
    return map((value) {
      try {
        return mapper(value);
      } catch (e) {
        onError?.call(value, e);
        return null;
      }
    }).whereType<R>();
  }

  T? get firstOrNull {
    return isEmpty ? null : first;
  }

  T? get lastOrNull {
    return isEmpty ? null : last;
  }

  Map<K, V> mapToMap<K, V>(MapEntry<K, V> Function(T value) mapper) {
    return map(mapper).toMap();
  }

  Iterable<T> repeat(int amount) {
    return List.filled(amount, this).expand((i) => i);
  }
}

extension NullableIterableExtensions<T> on Iterable<T?> {
  Iterable<T> whereNonNull() {
    return where((item) => item != null).map((item) => item!);
  }
}

extension MapExtensions<K, V> on Map<K, V> {
  /// Returns a copy of the map.
  /// Can provide an optional key copier or value copier to copy the items in a specific way.
  Map<K, V> copy({K Function(K value)? keyCopier, V Function(V value)? valueCopier}) {
    if (keyCopier == null && valueCopier == null) return Map.of(this);

    return map((key, value) => MapEntry(keyCopier?.call(key) ?? key, valueCopier?.call(value) ?? value));
  }

  /// Simply sets the value of [key] to [value], just like `map[key] = value`
  void set(K key, V value) {
    this[key] = value;
  }

  void replaceWhere(bool Function(K key, V value) predicate, V Function(K key, V value) replacer) {
    final data = copy();
    data.forEach((key, value) {
      if (predicate(key, value)) {
        this[key] = replacer(key, value);
      }
    });
  }

  /// Maps the key-value pairs of this map into an iterable.
  Iterable<R> mapToIterable<R>(R Function(K key, V value) mapper) {
    return entries.map((entry) => mapper(entry.key, entry.value));
  }

  Map<K, V> where(bool Function(K key, V value) predicate) {
    return entries.where((entry) => predicate(entry.key, entry.value)).toMap();
  }

  Map<K, V2> mapValues<V2>(V2 Function(K key, V value) mapper) {
    return map((key, value) => MapEntry(key, mapper(key, value)));
  }

  Map replaceWhereTraversed(
    bool Function(dynamic key, dynamic value) predicate,
    dynamic Function(dynamic key, dynamic value) replacer,
  ) {
    final output = {};
    forEach((key, dynamic value) {
      if (value is Map && !predicate(key, value)) {
        value = value.replaceWhereTraversed(predicate, replacer);
      }

      if (predicate(key, value)) {
        output[key] = replacer(key, value);
      } else {
        output[key] = value;
      }
    });
    return output;
  }

  bool isA<RK, RV>() {
    return keys.every((key) => key is RK) && values.every((value) => value is RV);
  }

  Iterable<(K, V)> get entryRecords => mapToIterable((key, value) => (key, value));

  Future<V> putIfAbsentAsync(K key, FutureOr<V> Function() ifAbsent) async {
    if (containsKey(key)) {
      return this[key] as V;
    }

    final value = await ifAbsent();
    this[key] = value;
    return value;
  }
}

extension JsonExtensions on Map<String, dynamic> {
  /// Ensures that a path can be walked from the root of this json by key.
  /// For example, if [keys] = ['top', 'mid', 'leaf'] and this is {'top': {'random': 3}},
  /// this will set the json to {'top': {'random': 3, 'mid': {'leaf': {}}}}
  void ensureNested(List<String> keys) {
    var map = this;
    for (final key in keys) {
      map = map.putIfAbsent(key, () => <String, dynamic>{});
    }
  }

  dynamic getPathed(String path) {
    final keys = path.split('/');

    dynamic current = this;
    for (var key in keys) {
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }

    return current;
  }

  void updatePathed(String path, dynamic Function(dynamic oldValue) updater) {
    final keys = path.split('/');

    dynamic current = this;
    for (var i = 0; i < keys.length - 1; i++) {
      final key = keys[i];
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        current[key] = <String, dynamic>{};
        current = current[key];
      }
    }

    final lastKey = keys.last;
    if (current is Map<String, dynamic>) {
      if (!current.containsKey(lastKey)) {
        current[lastKey] = updater(null);
      } else {
        current[lastKey] = updater(current[lastKey]);
      }
    }
  }

  void removePathed(String path) {
    final keys = path.split('/');

    dynamic current = this;
    for (int i = 0; i < keys.length - 1; i++) {
      final key = keys[i];

      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        return; // Path doesn't exist, so we exit early.
      }
    }

    final lastKey = keys.last;
    if (current is Map<String, dynamic> && current.containsKey(lastKey)) {
      current.remove(lastKey);
    }
  }
}

extension IterableEntriesExtensions<K, V> on Iterable<MapEntry<K, V>> {
  /// Maps the entries to another iterable.
  Iterable<R> mapEntries<R>(R Function(K key, V value) mapper) {
    return map((entry) => mapper(entry.key, entry.value));
  }

  /// Maps the entries to a map.
  Map<K2, V2> mapToMap<K2, V2>(MapEntry<K2, V2> Function(K key, V value) mapper) {
    return Map.fromEntries(mapEntries(mapper));
  }

  /// Converts the entries to a map.
  Map<K, V> toMap() {
    return Map.fromEntries(this);
  }
}
