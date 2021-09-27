import '../export.dart';

/// ID generator that simply counts up by 1 for each object.
class IncrementalIdGenerator<T> extends IdGenerator<T, int> {
  int _count;

  IncrementalIdGenerator([int initialId = 0]) : _count = initialId;

  @override
  int getId(T? object) {
    return _count++;
  }
}

/// ID generator that counts by up 1 for each object and adds a prefix before the number.
class PrefixedIncrementalIdGenerator<T> extends IdGenerator<T, String> {
  /// The prefix before the count.
  final String prefix;

  int _count;

  PrefixedIncrementalIdGenerator({required this.prefix, int initialId: 0}) : _count = initialId;

  @override
  String getId(T? object) {
    return prefix + (_count++).toString();
  }
}
