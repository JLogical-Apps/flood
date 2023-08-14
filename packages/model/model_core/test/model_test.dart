import 'dart:async';

import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
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

    final model = Model(loader: () async {
      loadCount++;
      return loadCount;
    }).asyncMap((value) async {
      await modelHaltCompleter.future;
      return value;
    });

    expect(loadCount, 0);
    expect(model.state.isEmpty, isTrue);

    final loadFuture = model.load();

    expect(loadCount, 1);
    expect(model.state.isLoading, isTrue);
    expect(model.state.getOrNull(), isNull);

    modelHaltCompleter.complete();
    await loadFuture;

    expect(loadCount, 1);
    expect(model.state.isLoaded, isTrue);
    expect(model.state.getOrNull(), 1);
  });

  test('model async mapping stream', () async {
    var loadCount = 0;

    final model = Model(loader: () async {
      loadCount++;
      return loadCount;
    }).asyncMap((value) async {
      return value;
    });

    expect(
        model.stateX,
        emitsInOrder(<FutureValue<int>>[
          FutureValue.empty(),
          FutureValue.empty(),
          FutureValue.loading(),
          FutureValue.loaded(1),
        ]));

    await model.load();
  });

  test('model flat map stream', () async {
    var loadCount = 0;

    final model = Model(loader: () async {
      loadCount++;
      return loadCount;
    }).flatMap((value) => Model(loader: () => value.toString()));

    expect(
        model.stateX,
        emitsInOrder(<FutureValue<String>>[
          FutureValue.empty(),
          FutureValue.loading(),
          FutureValue.loading(),
          FutureValue.loaded('1'),
        ]));

    await model.load();
  });

  test('value stream model', () async {
    final intSubject = BehaviorSubject.seeded(0);

    final valueStreamModel = Model.fromValueStream(
      intSubject.mapWithValue((value) => FutureValue.loaded(value)),
      onLoad: () => intSubject.value += 1,
    );

    expect(valueStreamModel.getOrNull(), 0);

    await valueStreamModel.load();

    expect(valueStreamModel.getOrNull(), 1);
  });

  test('joining models together', () async {
    final model1 = Model.value(1);
    final model2 = Model(loader: () => 2);

    final joined = Model.union([model1, model2]);

    expectLater(
        joined.stateX.distinct(),
        emitsInOrder([
          FutureValue.empty<List>(),
          FutureValue.loading<List>(),
          FutureValue.loaded<List>([1, 2]),
        ]));

    expect(await joined.getOrLoad(), [1, 2]);
  });
}
