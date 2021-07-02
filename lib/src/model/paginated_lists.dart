import 'dart:math';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';

/// Util methods for paginating lists.
class PaginatedLists {
  static const _uuid = Uuid();

  /// Paginates the list of [items] with pages of size [size].
  /// If [idGenerator] is null, then generates a uuid for each item.
  static PaginationResult<T> paginate<T>({required List<T> items, String idGenerator(T)?, required int size}) {
    return _paginate(items: items, idGenerator: idGenerator, size: size, lastIndex: 0);
  }

  static PaginationResult<T> _paginate<T>({required List<T> items, String idGenerator(T)?, required int size, required int lastIndex}) {
    idGenerator ??= (_) => _uuid.v4();
    var maxIndex = lastIndex + size;
    var results = items.getRange(lastIndex, min(items.length, maxIndex)).toList();
    return PaginationResult(
      results: {for (var result in results) idGenerator(result): result},
      nextPageGetter: maxIndex >= items.length ? null : () => _paginate(items: items, idGenerator: idGenerator, size: size, lastIndex: maxIndex),
    );
  }
}

/// Extensions for paginated lists.
extension PaginateListExtensions<T> on List<T> {
  /// Paginates the list with pages of size [size].
  /// If [idGenerator] is null, then generates a uuid for each item.
  PaginationResult<T> paginate({String idGenerator(T)?, int size: 10}) {
    return PaginatedLists.paginate(items: this, size: size, idGenerator: idGenerator);
  }
}
