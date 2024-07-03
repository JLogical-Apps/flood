import 'dart:async';

import 'package:drop_core/src/query/pagination/query_result_page.dart';
import 'package:utils_core/utils_core.dart';

class BatchQueryResultPage<T> with IsQueryResultPage<T> {
  final List<T> allItems;
  final int batchSize;

  BatchQueryResultPage({required this.allItems, required this.batchSize});

  @override
  List<T> get items => allItems.take(batchSize).toList();

  @override
  FutureOr<QueryResultPage<T>> Function()? get nextPageGetter =>
      _getNextPage(batchSize)?.mapIfNonNull((nextPage) => () => nextPage);

  QueryResultPage<T>? _getNextPage(int startOffset) {
    if (startOffset >= allItems.length) {
      return null;
    }

    return QueryResultPage(
      items: allItems.skip(startOffset).take(batchSize).toList(),
      nextPageGetter: _getNextPage(startOffset + batchSize)?.mapIfNonNull((nextPage) => () => nextPage),
    );
  }
}
