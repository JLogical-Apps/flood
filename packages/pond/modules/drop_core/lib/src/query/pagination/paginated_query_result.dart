import 'dart:async';

import 'package:drop_core/drop_core.dart';
import 'package:rxdart/rxdart.dart';

class PaginatedQueryResult<T> with IsQueryResultPage<T> {
  final QueryResultPage<T> initialPage;
  final BehaviorSubject<QueryResultPage<T>> pageX;
  final FutureOr Function(QueryResultPage<T> page)? onPageLoaded;

  QueryResultPage<T> get page => pageX.value;

  PaginatedQueryResult({required this.initialPage, this.onPageLoaded}) : pageX = BehaviorSubject.seeded(initialPage);

  Future initialize() async {
    await onPageLoaded?.call(page);
  }

  @override
  Future<List<T>> getItems() async => await page.getItems();

  @override
  FutureOr<QueryResultPage<T>> Function()? get nextPageGetter => page.hasNext
      ? () async {
          final nextPage = await page.getNextPage();
          pageX.value = await page.append(nextPage);
          await onPageLoaded?.call(nextPage);
          return nextPage;
        }
      : null;

  Future<void> loadNextPage() async {
    await getNextPage();
  }

  Future<void> reload() async {
    pageX.value = initialPage;
    await onPageLoaded?.call(page);
  }

  PaginatedQueryResult<R> map<R>(FutureOr<R> Function(T item) mapper) {
    return PaginatedQueryResult(
      initialPage: page.withListener(onNextPage: (nextPage) => onPageLoaded?.call(nextPage)).map(mapper),
    );
  }

  PaginatedQueryResult<T> withListener({
    FutureOr Function(List<T> items)? onLoaded,
    FutureOr Function(QueryResultPage<T> page)? onNextPage,
  }) {
    return PaginatedQueryResult(initialPage: page.withListener(onLoaded: onLoaded, onNextPage: onNextPage));
  }
}
