import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:utils_core/src/stream/stream_extensions.dart';

void main() {
  test('mapWithValue', () {
    final intSubject = BehaviorSubject.seeded(0);
    final toStringStream = intSubject.mapWithValue((value) => value.toString());

    expect(intSubject.value, 0);
    expect(toStringStream.value, '0');

    intSubject.value = 1;

    expect(intSubject.value, 1);
    expect(toStringStream.value, '1');
  });

  test('mapWithValue stream', () {
    final intSubject = BehaviorSubject.seeded(0);
    final toStringStream = intSubject.mapWithValue((value) => value.toString());

    expectLater(toStringStream, emitsInOrder(['0', '0', '1', '2']));

    intSubject.value = 1;
    intSubject.value = 2;
  });

  test('asyncMapWithValue', () async {
    var modelHaltCompleter = Completer();
    var shouldThrowError = false;

    final intSubject = BehaviorSubject.seeded(0);
    final toStringStream = intSubject.asyncMapWithValue(
      initialValue: '',
      (value) async {
        await modelHaltCompleter.future;
        if (shouldThrowError) {
          throw Exception();
        }
        return value.toString();
      },
    );

    expect(intSubject.value, 0);
    expect(toStringStream.value, '');

    final subscription = toStringStream.listen((data) {}, onError: (_) {});

    modelHaltCompleter.complete();
    await Future(() {});

    expect(intSubject.value, 0);
    expect(toStringStream.value, '0');

    modelHaltCompleter = Completer();

    intSubject.value = 1;

    modelHaltCompleter.complete();
    await Future(() {});

    expect(intSubject.value, 1);
    expect(toStringStream.value, '1');

    shouldThrowError = true;
    modelHaltCompleter = Completer();

    intSubject.value = 2;

    modelHaltCompleter.complete();
    await Future(() {});

    expect(toStringStream.value, '1');
    expect(toStringStream.error, isNotNull);
    expect(toStringStream.stackTrace, isNotNull);

    shouldThrowError = false;
    modelHaltCompleter = Completer();

    intSubject.value = 3;

    modelHaltCompleter.complete();
    await Future(() {});

    expect(toStringStream.value, '3');
    expect(toStringStream.errorOrNull, isNull);
    expect(toStringStream.stackTrace, isNull);

    subscription.cancel();
  });

  test('switchMapWithValue', () async {
    ValueStream<int> getRangeStream(int limit) {
      return RangeStream(0, limit).publishValueSeeded(0).autoConnect();
    }

    final intSubject = BehaviorSubject.seeded(0);
    final rangeStream = intSubject.switchMapWithValue(getRangeStream);

    expect(rangeStream.value, 0);

    expectLater(rangeStream, emitsInOrder([0, 0, 0, 0, 0, 1, 0, 0, 1, 2]));

    await Future(() {});
    intSubject.value = 1;
    await Future(() {});
    intSubject.value = 2;
  });

  test('combineLatestWithValue', () async {
    final intSubjects = [
      BehaviorSubject.seeded(0),
      BehaviorSubject.seeded(0),
      BehaviorSubject.seeded(0),
    ];
    final combinedStream = intSubjects.combineLatestWithValue((ints) => ints);

    expect(combinedStream.value, [0, 0, 0]);

    expectLater(
        combinedStream,
        emitsInOrder([
          [0, 0, 0],
          [0, 0, 0],
          [1, 0, 0],
          [2, 0, 0]
        ]));

    intSubjects[0].value = 1;
    await Future(() {});
    intSubjects[0].value = 2;
  });
}
