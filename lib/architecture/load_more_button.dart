import 'package:flutter/material.dart';
import 'package:jlogical_utils/architecture/multi_model_cubit.dart';
import 'package:jlogical_utils/architecture/multi_model_state.dart';
import 'package:jlogical_utils/widgets/loading_widget.dart';

/// Button to load more elements of a multi model cubit.
class LoadMoreButton extends StatelessWidget {
  final MultiModelCubit cubit;
  final MultiModelLoadedState state;

  const LoadMoreButton({@required this.cubit, @required this.state}) : super();

  @override
  Widget build(BuildContext context) {
    return Align(
      child: state.isLoading
          ? LoadingWidget()
          : ElevatedButton(
              child: Text('LOAD MORE'),
              onPressed: state.isLoading
                  ? null
                  : () {
                      cubit.loadNext();
                    },
            ),
    );
  }
}
