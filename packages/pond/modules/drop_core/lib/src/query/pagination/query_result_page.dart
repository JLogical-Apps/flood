import 'dart:async';

import 'package:drop_core/src/query/pagination/batch_query_result_page.dart';
import 'package:drop_core/src/query/pagination/mapper_query_result_page.dart';

abstract class QueryResultPage<T> {
  List<T> get items;

  FutureOr<QueryResultPage<T>> Function()? get nextPageGetter;

  factory QueryResultPage({required List<T> items, FutureOr<QueryResultPage<T>> Function()? nextPageGetter}) =>
      _QueryResultPageImpl(
        items: items,
        nextPageGetter: nextPageGetter,
      );

  factory QueryResultPage.batched({required List<T> items, required int batchSize}) => BatchQueryResultPage(
        allItems: items,
        batchSize: batchSize,
      );
}

extension QueryResultPageDefaults<T> on QueryResultPage<T> {
  bool get hasNext => nextPageGetter != null;

  Future<QueryResultPage<T>?> getNextPageOrNull() async {
    return nextPageGetter?.call();
  }

  Future<QueryResultPage<T>> getNextPage() async {
    return nextPageGetter!.call();
  }

  MapperQueryResultPage<T, R> map<R>(R Function(T source) mapper) {
    return MapperQueryResultPage(sourceQueryResultPage: this, mapper: mapper);
  }

  Future<List<T>> combineAll() async {
    final items = <T>[];

    QueryResultPage<T>? nextPage = this;
    do {
      items.addAll(nextPage!.items);
      nextPage = await nextPage.getNextPageOrNull();
    } while (nextPage != null);

    return items;
  }
}

mixin IsQueryResultPage<T> implements QueryResultPage<T> {}

class _QueryResultPageImpl<T> with IsQueryResultPage<T> {
  @override
  final List<T> items;

  @override
  FutureOr<QueryResultPage<T>> Function()? nextPageGetter;

  _QueryResultPageImpl({required this.items, this.nextPageGetter});
}
