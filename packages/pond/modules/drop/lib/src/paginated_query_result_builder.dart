import 'package:drop_core/drop_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:utils/utils.dart';

class PaginatedQueryResultBuilder<T> extends HookWidget {
  final PaginatedQueryResult<T> queryResult;
  final Widget Function(List<T> items, Future Function()? loadNext) builder;

  const PaginatedQueryResultBuilder({required this.queryResult, required this.builder});

  @override
  Widget build(BuildContext context) {
    final itemsModel = useMemoized(
      () => Model.fromValueStream(queryResult.pageX.asyncMapWithValue<FutureValue<List<T>>>(
        (page) async => FutureValue.loaded(await page.getItems()),
        initialValue: FutureValue.loading(),
      )),
      [queryResult],
    );

    return ModelBuilder(
      model: itemsModel,
      builder: (List<T> items) {
        return builder(
          items,
          queryResult.hasNext ? () => queryResult.loadNextPage() : null,
        );
      },
    );
  }
}
