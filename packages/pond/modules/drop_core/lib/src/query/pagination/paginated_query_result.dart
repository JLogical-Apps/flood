import 'dart:async';

import 'package:drop_core/drop_core.dart';
import 'package:rxdart/rxdart.dart';

class PaginatedQueryResult<T> with IsQueryResultPage<T> {
  final QueryResultPage<T> initialPage;
  final BehaviorSubject<QueryResultPage<T>> pageX;
  final FutureOr Function(List<T> items)? onPageLoaded;

  QueryResultPage<T> get page => pageX.value;

  PaginatedQueryResult({required this.initialPage, this.onPageLoaded}) : pageX = BehaviorSubject.seeded(initialPage);

  Future initialize() async {
    await onPageLoaded?.call(items);
  }

  @override
  List<T> get items => page.items;

  @override
  FutureOr<QueryResultPage<T>> Function()? get nextPageGetter => page.hasNext
      ? () async {
          final nextPage = await page.getNextPage();
          pageX.value = await page.append(nextPage);
          await onPageLoaded?.call(nextPage.items);
          return nextPage;
        }
      : null;

  Future<void> loadNextPage() async {
    await getNextPage();
  }

  Future<void> reload() async {
    pageX.value = initialPage;
    await onPageLoaded?.call(items);
  }

  PaginatedQueryResult<R> map<R>(R Function(T item) mapper) {
    return PaginatedQueryResult(
      initialPage: page.withListener(onNextPage: (nextPage) => onPageLoaded?.call(nextPage.items)).map(mapper),
    );
  }

  PaginatedQueryResult<T> withListener(FutureOr Function(QueryResultPage<T> page) onNextPage) {
    return PaginatedQueryResult(
      initialPage: page.withListener(onNextPage: (page) => onNextPage(page)),
      onPageLoaded: onPageLoaded,
    );
  }

  Future<PaginatedQueryResult<R>> withPageMapper<R>({
    required FutureOr<List<R>> Function(List<T>) pageMapper,
    required FutureOr<List<T>> Function(List<R>) reversePageMapper,
  }) async {
    return PaginatedQueryResult(
      initialPage: page.withPageMapper(items: await pageMapper(items), mapper: pageMapper),
      onPageLoaded: (items) async => await onPageLoaded?.call(await reversePageMapper(items)),
    );
  }

  @override
  String toString() {
    return 'Paginated($items)';
  }
}
