import 'dart:math';

import 'package:jlogical_utils/src/persistence/export_core.dart';

import 'pagination_result.dart';

/// Util methods for paginating lists.
class PaginatedLists {
  PaginatedLists._();

  /// Paginates the list of [items] with pages of size [size].
  /// If [idGenerator] is null, then generates a uuid for each item.
  static PaginationResult<T> paginate<T>({required List<T> items, String idGenerator(T value)?, required int size}) {
    return _paginate(items: items, idGenerator: idGenerator, size: size, lastIndex: 0);
  }

  static PaginationResult<T> _paginate<T>(
      {required List<T> items, String idGenerator(T value)?, required int size, required int lastIndex}) {
    idGenerator ??= (_) => UuidIdGenerator().getId();
    var maxIndex = lastIndex + size;
    var results = items.getRange(lastIndex, min(items.length, maxIndex)).toList();
    return PaginationResult(
      results: {for (var result in results) idGenerator(result): result},
      nextPageGetter: maxIndex >= items.length
          ? null
          : () => _paginate(items: items, idGenerator: idGenerator, size: size, lastIndex: maxIndex),
    );
  }
}

extension PaginateListExtensions<T> on List<T> {
  /// Paginates the list with pages of size [size].
  /// If [idGenerator] is null, then generates a uuid for each item.
  PaginationResult<T> paginate({String idGenerator(T value)?, int size: 10}) {
    return PaginatedLists.paginate(items: this, size: size, idGenerator: idGenerator);
  }
}
