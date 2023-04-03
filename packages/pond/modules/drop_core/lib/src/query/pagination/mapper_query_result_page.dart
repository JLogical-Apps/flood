import 'dart:async';

import 'package:drop_core/src/query/pagination/query_result_page.dart';
import 'package:utils_core/utils_core.dart';

class MapperQueryResultPage<T, R> with IsQueryResultPage<R> {
  final QueryResultPage<T> sourceQueryResultPage;
  final FutureOr<R> Function(T source) mapper;

  MapperQueryResultPage({required this.sourceQueryResultPage, required this.mapper});

  @override
  FutureOr<QueryResultPage<R>> Function()? get nextPageGetter =>
      sourceQueryResultPage.nextPageGetter.mapIfNonNull((nextPageGetter) => () => nextPageMapper(nextPageGetter));

  Future<QueryResultPage<R>> nextPageMapper(FutureOr<QueryResultPage<T>> Function() nextPageGetter) async {
    final sourceNextPage = await nextPageGetter();

    return QueryResultPage(
      items: await mapItems(await sourceNextPage.getItems()),
      nextPageGetter:
          sourceNextPage.nextPageGetter?.mapIfNonNull((nextPageGetter) => () => nextPageMapper(nextPageGetter)),
    );
  }

  @override
  Future<List<R>> getItems() async {
    return mapItems(await sourceQueryResultPage.getItems());
  }

  Future<List<R>> mapItems(List<T> sourceItems) async {
    return (await Future.wait(sourceItems.map((item) async => await mapper(item)))).toList();
  }
}
