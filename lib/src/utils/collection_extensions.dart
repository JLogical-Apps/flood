extension IterableExtensions<T> on Iterable<T> {
  /// Returns the sum of the elements of the iterable based on a property of the items in the list.
  num sumBy(num f(T element)) {
    num sum = 0;
    for (var item in this) {
      sum += f(item);
    }
    return sum;
  }

  /// Returns a copy of the iterable.
  /// Can provide an optional copier to copy the items in a specific way.
  List<T> copy([T copier(T value)?]) {
    if (copier == null) return List.of(this);

    return List.of(map(copier));
  }

  /// Safely maps the elements of this iterable into a new one.
  /// If a mapper throws an exception, it is not included in the map and calls [onError].
  Iterable<R> tryMap<R>(R mapper(T value),
      {void onError(T value, dynamic error)?}) {
    return map((value) {
      try {
        return mapper(value);
      } catch (e) {
        onError?.call(value, e);
        return null;
      }
    }).whereType<R>();
  }
}

extension MapExtensions<K, V> on Map<K, V> {
  /// Returns a copy of the map.
  /// Can provide an optional key copier or value copier to copy the items in a specific way.
  Map<K, V> copy({K keyCopier(K value)?, V valueCopier(V value)?}) {
    if (keyCopier == null && valueCopier == null) return Map.of(this);

    return map((key, value) => MapEntry(
        keyCopier?.call(key) ?? key, valueCopier?.call(value) ?? value));
  }

  /// Simply sets the value of [key] to [value], just like `map[key] = value`
  void set(K key, V value) {
    this[key] = value;
  }

  /// Maps the key-value pairs of this map into an iterable.
  Iterable<R> mapToIterable<R>(R mapper(K key, V value)) {
    return entries.map((entry) => mapper(entry.key, entry.value));
  }
}

extension JsonExtensions on Map<String, dynamic> {
  /// Ensures that a path can be walked from the root of this json by key.
  /// For example, if [keys] = ['top', 'mid', 'leaf'] and this is {'top': {'random': 3}},
  /// this will set the json to {'top': {'random': 3, 'mid': {'leaf': {}}}}
  Map<String, dynamic> ensureNested(List<String> keys) {
    var map = this;
    for (final key in keys) {
      map = map.putIfAbsent(key, () => <String, dynamic>{});
    }
    return this;
  }
}

extension IterableEntriesExtensions<K, V> on Iterable<MapEntry<K, V>> {
  /// Maps the entries to another iterable.
  Iterable<R> mapEntries<R>(R mapper(K key, V value)) {
    return map((entry) => mapper(entry.key, entry.value));
  }

  /// Maps the entries to a map.
  Map<K2, V2> mapToMap<K2, V2>(MapEntry<K2, V2> mapper(K key, V value)) {
    return Map.fromEntries(mapEntries(mapper));
  }

  /// Converts the entries to a map.
  Map<K, V> toMap() {
    return Map.fromEntries(this);
  }
}
