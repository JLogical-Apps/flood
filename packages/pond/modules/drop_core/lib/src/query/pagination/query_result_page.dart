import 'dart:async';

import 'package:drop_core/src/query/pagination/batch_query_result_page.dart';
import 'package:drop_core/src/query/pagination/mapper_query_result_page.dart';
import 'package:drop_core/src/query/pagination/query_result_page_listener.dart';

abstract class QueryResultPage<T> {
  FutureOr<List<T>> getItems();

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

  MapperQueryResultPage<T, R> map<R>(FutureOr<R> Function(T source) mapper) {
    return MapperQueryResultPage(sourceQueryResultPage: this, mapper: mapper);
  }

  QueryResultPageListener<T> withListener({
    FutureOr Function(List<T> items)? onLoaded,
    FutureOr Function(QueryResultPage<T> page)? onNextPage,
  }) {
    return QueryResultPageListener(
      queryResultPage: this,
      onLoaded: onLoaded,
      onNextPage: onNextPage,
    );
  }

  Future<QueryResultPage<T>> append(QueryResultPage<T> nextPage) async {
    return QueryResultPage(
      items: (await getItems()) + (await nextPage.getItems()),
      nextPageGetter: nextPage.nextPageGetter,
    );
  }

  Future<List<T>> combineAll() async {
    final items = <T>[];

    QueryResultPage<T>? nextPage = this;
    do {
      items.addAll(await nextPage!.getItems());
      nextPage = await nextPage.getNextPageOrNull();
    } while (nextPage != null);

    return items;
  }
}

mixin IsQueryResultPage<T> implements QueryResultPage<T> {}

class _QueryResultPageImpl<T> with IsQueryResultPage<T> {
  final List<T> _items;

  @override
  FutureOr<QueryResultPage<T>> Function()? nextPageGetter;

  _QueryResultPageImpl({required List<T> items, this.nextPageGetter}) : _items = items;

  @override
  FutureOr<List<T>> getItems() => _items;
}

abstract class QueryResultPageWrapper<T> implements QueryResultPage<T> {
  QueryResultPage<T> get queryResultPage;
}

mixin IsQueryResultPageWrapper<T> implements QueryResultPageWrapper<T> {
  @override
  FutureOr<List<T>> getItems() => queryResultPage.getItems();

  @override
  FutureOr<QueryResultPage<T>> Function()? get nextPageGetter => queryResultPage.nextPageGetter;
}
