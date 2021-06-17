extension IntIterableUtils on Iterable<int> {
  int getSum() {
    var value = 0;
    for (var item in this) {
      value += item;
    }
    return value;
  }
}

extension ListUtils<T> on List<T> {
  /// Returns the sum of the elements of the list based on a property of the items in the list.
  num sumBy(num f(T element)) {
    num sum = 0;
    for (var item in this) {
      sum += f(item);
    }
    return sum;
  }

  /// Returns a copy of the list.
  /// Can provide an optional copier to copy the items in a specific way.
  List<T> copy([T copier(T value)?]) {
    if (copier == null) return List.of(this);

    return List.of(map(copier));
  }
}
