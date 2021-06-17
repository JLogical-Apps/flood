extension IntIterableUtils on Iterable<int> {
  int getSum() {
    var value = 0;
    for (var item in this) {
      value += item;
    }
    return value;
  }
}

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
  Iterable<R> tryMap<R>(R mapper(T value), {void onError(T value, dynamic error)?}) {
    return map((value) {
      try {
        return mapper(value);
      } catch (e) {
        onError?.call(value, e);
        return null;
      }
    }).whereType<R>();
  }

  /// Returns the first element that satisfies the predicate.
  /// If no element is found, calls [orElse], or null if not initialized.
  T? firstWhereOrNull(bool predicate(T value), {T? orElse()?}) {
    for (var element in this) {
      if (predicate(element)) return element;
    }
    return orElse?.call();
  }
}
