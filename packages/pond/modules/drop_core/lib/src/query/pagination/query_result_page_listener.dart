import 'dart:async';

import 'package:drop_core/src/query/pagination/query_result_page.dart';

class QueryResultPageListener<T> with IsQueryResultPageWrapper<T> {
  @override
  final QueryResultPage<T> queryResultPage;

  final FutureOr Function(QueryResultPage<T> page)? onNextPage;

  QueryResultPageListener({required this.queryResultPage, this.onNextPage});

  @override
  FutureOr<QueryResultPage<T>> Function()? get nextPageGetter => super.nextPageGetter == null
      ? null
      : () async {
          final nextPage = await queryResultPage.getNextPage();
          await onNextPage?.call(nextPage);
          return nextPage;
        };
}
