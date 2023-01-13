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

  test('asyncMapWithValue', () async {
    var modelHaltCompleter = Completer();
    var modelFinishCompleter = Completer();

    final intSubject = BehaviorSubject.seeded(0);
    final toStringStream = intSubject.asyncMapWithValue(
      initialValue: '',
      (value) async {
        await modelHaltCompleter.future;
        modelFinishCompleter.complete();
        return value.toString();
      },
    );

    expect(intSubject.value, 0);
    expect(toStringStream.value, '');

    final subscription = toStringStream.listen((data) {});

    modelHaltCompleter.complete();
    await modelFinishCompleter.future;

    expect(intSubject.value, 0);
    expect(toStringStream.value, '0');

    modelHaltCompleter = Completer();
    modelFinishCompleter = Completer();

    intSubject.value = 1;

    modelHaltCompleter.complete();
    await modelFinishCompleter.future;

    expect(intSubject.value, 1);
    expect(toStringStream.value, '1');

    subscription.cancel();
  });
}
