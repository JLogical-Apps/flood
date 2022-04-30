import 'package:flutter/material.dart';

import '../widgets/export.dart';
import 'paginated_model_list.dart';

/// A button that handles loading more pages in a paginated model list.
class LoadMoreButton<T> extends StatelessWidget {
  /// The paginated model list to get more pages from.
  final PaginatedModelList<T> paginatedModelList;

  const LoadMoreButton({required this.paginatedModelList});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: paginatedModelList.valueX,
      builder: (context, snap) {
        return paginatedModelList.value.maybeWhen(
          loaded: (page) => page.hasNextPage
              ? FutureButton(
                  child: Text('LOAD MORE'),
                  onPressed: () async {
                    await paginatedModelList.loadNextPage();
                  },
                )
              : Container(),
          orElse: () => Container(),
        );
      },
    );
  }
}
