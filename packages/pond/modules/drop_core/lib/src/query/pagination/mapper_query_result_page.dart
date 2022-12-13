import 'dart:async';

import 'package:drop_core/src/query/pagination/query_result_page.dart';
import 'package:utils_core/utils_core.dart';

class MapperQueryResultPage<T, R> with IsQueryResultPage<R> {
  final QueryResultPage<T> sourceQueryResultPage;
  final R Function(T source) mapper;

  MapperQueryResultPage({required this.sourceQueryResultPage, required this.mapper});

  @override
  FutureOr<QueryResultPage<R>> Function()? get nextPageGetter =>
      sourceQueryResultPage.nextPageGetter.mapIfNonNull((nextPageGetter) => () => nextPageMapper(nextPageGetter));

  Future<QueryResultPage<R>> nextPageMapper(FutureOr<QueryResultPage<T>> Function() nextPageGetter) async {
    final sourceNextPage = await nextPageGetter();

    return QueryResultPage(
      items: sourceNextPage.items.map(mapper).toList(),
      nextPageGetter:
          sourceNextPage.nextPageGetter?.mapIfNonNull((nextPageGetter) => () => nextPageMapper(nextPageGetter)),
    );
  }

  @override
  List<R> get items => sourceQueryResultPage.items.map(mapper).toList();
}
