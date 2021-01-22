import 'package:flutter/material.dart';
import 'package:jlogical_utils/architecture/multi_model_cubit.dart';

import 'multi_model_state.dart';

/// Button to load more of a multi model cubit.
class LoadMoreButton extends StatelessWidget {
  final MultiModelCubit cubit;
  final MultiModelLoadedState state;

  const LoadMoreButton({@required this.cubit, @required this.state});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: state.canLoadMore
          ? RaisedButton(
              child: Text('LOAD MORE'),
              onPressed: () {
                cubit.loadNext();
              },
            )
          : Container(),
    );
  }
}
