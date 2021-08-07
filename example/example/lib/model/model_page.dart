import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Demonstrates mapping models together.
class ModelPage extends HookWidget {
  /// Whenever this model is loaded, it generates a number from [0, 9)
  final Model<int> randomNumberModel = Model(
    loader: () async {
      await Future.delayed(Duration(seconds: 1));
      return Random().nextInt(100);
    },
  );

  /// This model's value is based off [randomNumberModel].
  /// Whenever this model is loaded, it actually just loads [randomNumberModel].
  /// The changes in [randomNumberModel] is instantly reflected into this model.
  late final AsyncLoadable<bool> isEvenModel = randomNumberModel.map((value) => value.isEven);

  final Model<bool> coinFlipModel = Model(
    loader: () async {
      await Future.delayed(Duration(seconds: 1));
      return Random().nextBool();
    },
  );

  /// This model's value is based off both [isEvenModel] and [coinFlipModel].
  /// This model is defined as true when both its parents have true values.
  /// Whenever this model is loaded, it actually loads both its parents.
  /// The changes in its parents are instantly reflected into this model.
  late final AsyncLoadable<bool> isLuckyModel =
      [isEvenModel, coinFlipModel].combineLatest((values) => values.every((value) => value == true));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MODELS'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _modelRow(label: 'Random Number', model: randomNumberModel),
          _modelRow(label: 'Is Even', model: isEvenModel),
          _modelRow(label: 'Coin Flip', model: coinFlipModel),
          _modelRow(label: 'Is Lucky', model: isLuckyModel),
        ],
      ),
    );
  }

  Widget _modelRow<T>({required AsyncLoadable<T> model, required String label}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$label: '),
        ModelBuilder<T>(
          model: model,
          builder: (value) => Text(value.toString()),
        ),
        FutureButton(
          child: Text('LOAD'),
          onPressed: () async {
            await model.load();
          },
        ),
      ],
    );
  }
}
