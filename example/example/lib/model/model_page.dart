import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Demonstrates mapping models together.
class ModelPage extends HookWidget {
  /// Whenever this model is loaded, it generates a number from [0, 9)
  final Model<int> randomNumberModel = Model<int>(
    loader: () async {
      await Future.delayed(Duration(seconds: 1));
      return Random().nextInt(100);
    },
  );

  /// This model's value is based off [randomNumberModel].
  /// Whenever this model is loaded, it actually just loads [randomNumberModel],
  /// but the changes in [randomNumberModel] is instantly reflected into this model.
  late final isEvenModel = randomNumberModel.map((value) => value.isEven);

  @override
  Widget build(BuildContext context) {
    // Rebuild the page whenever the child model gets a new value.
    final maybeIsEven = useModel(isEvenModel).value;
    return RefreshScaffold(
      // Updating either [randomNumberModel] or [isEvenModel] will rebuild the page.
      // onRefresh: () => randomNumberModel.load(),
      onRefresh: () async {
        await isEvenModel.load();
        print('here');
      },
      body: Center(
        child: maybeIsEven.when(
          initial: () => LoadingWidget(),
          loaded: (isEven) => Text('Is Even? $isEven\nValue: ${randomNumberModel.getOrNull()}'),
          error: (error) => Text('Error: $error'),
        ),
      ),
    );
  }
}
