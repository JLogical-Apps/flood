import 'dart:async';

import 'package:model_core/model_core.dart';
import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('basic model loading', () async {
    var loadCount = 0;
    final model = Model(loader: () {
      loadCount++;
      return loadCount;
    });

    expect(loadCount, 0);
    expect(model.state.isEmpty, isTrue);

    await model.load();

    expect(loadCount, 1);
    expect(model.state.isLoaded, isTrue);
    expect(model.state.getOrNull(), 1);
  });

  test('model mapping', () async {
    var loadCount = 0;
    final model = Model(loader: () {
      loadCount++;
      return loadCount;
    }).map((loadCount) => loadCount.toString());

    expect(loadCount, 0);
    expect(model.state.isEmpty, isTrue);

    await model.load();

    expect(loadCount, 1);
    expect(model.state.isLoaded, isTrue);
    expect(model.state.getOrNull(), '1');
  });

  test('model async mapping', () async {
    var loadCount = 0;
    final modelHaltCompleter = Completer();
    final modelFinishCompleter = Completer();

    final model = Model(loader: () async {
      loadCount++;
      return loadCount;
    }).asyncMap((value) async {
      await modelHaltCompleter.future;
      modelFinishCompleter.complete();
      return value;
    });

    expect(loadCount, 0);
    expect(model.state.isEmpty, isTrue);

    await model.load();

    expect(loadCount, 1);
    expect(model.state.isLoading, isTrue);
    expect(model.state.getOrNull(), isNull);

    modelHaltCompleter.complete();
    await modelFinishCompleter.future;

    expect(loadCount, 1);
    expect(model.state.isLoaded, isTrue);
    expect(model.state.getOrNull(), 1);
  });
}
