import 'dart:async';

import 'package:drop_core/src/query/pagination/query_result_page.dart';
import 'package:utils_core/utils_core.dart';

class PageMapperQueryResultPage<T, R> with IsQueryResultPage<R> {
  final QueryResultPage<T> sourceQueryResultPage;
  final FutureOr<List<R>> Function(List<T> source) mapper;

  @override
  final List<R> items;

  PageMapperQueryResultPage({required this.sourceQueryResultPage, required this.items, required this.mapper});

  @override
  FutureOr<QueryResultPage<R>> Function()? get nextPageGetter =>
      sourceQueryResultPage.nextPageGetter.mapIfNonNull((nextPageGetter) => () => nextPageMapper(nextPageGetter));

  Future<QueryResultPage<R>> nextPageMapper(FutureOr<QueryResultPage<T>> Function() nextPageGetter) async {
    final sourceNextPage = await nextPageGetter();

    return QueryResultPage(
      items: await mapItems(sourceNextPage.items),
      nextPageGetter:
          sourceNextPage.nextPageGetter?.mapIfNonNull((nextPageGetter) => () => nextPageMapper(nextPageGetter)),
    );
  }

  Future<List<R>> mapItems(List<T> sourceItems) async {
    return await mapper(sourceItems);
  }
}
