import 'dart:async';

import 'package:drop_core/drop_core.dart';
import 'package:rxdart/rxdart.dart';

class PaginatedQueryResult<T> with IsQueryResultPage<T> {
  final BehaviorSubject<QueryResultPage<T>> pageX;
  final FutureOr Function(QueryResultPage<T> page)? onPageLoaded;

  QueryResultPage<T> get page => pageX.value;

  PaginatedQueryResult({required QueryResultPage<T> page, this.onPageLoaded}) : pageX = BehaviorSubject.seeded(page) {
    onPageLoaded?.call(page);
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

  PaginatedQueryResult<R> map<R>(FutureOr<R> Function(T item) mapper) {
    return PaginatedQueryResult(
        page: page.withListener(onNextPage: (nextPage) => onPageLoaded?.call(nextPage)).map(mapper));
  }
}
