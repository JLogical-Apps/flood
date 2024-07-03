import 'dart:async';

import 'package:drop_core/src/query/pagination/query_result_page.dart';

class QueryResultPageListener<T> with IsQueryResultPageWrapper<T> {
  @override
  final QueryResultPage<T> queryResultPage;

  final FutureOr Function(List<T> items)? onLoaded;
  final FutureOr Function(QueryResultPage<T> page)? onNextPage;

  QueryResultPageListener({required this.queryResultPage, this.onLoaded, this.onNextPage});

  @override
  Future<List<T>> getItems() async {
    final items = await super.getItems();
    await onLoaded?.call(items);
    return items;
  }

  @override
  FutureOr<QueryResultPage<T>> Function()? get nextPageGetter => super.nextPageGetter == null
      ? null
      : () async {
          final nextPage = await queryResultPage.getNextPage();
          onNextPage?.call(nextPage);
          return nextPage;
        };
}
