import 'dart:async';

import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/utils/synchronizable.dart';

mixin WithKeySynchronizable<L> implements Synchronizable<L> {
  Map<L, Completer> _lockCompleters = {};

  L? _currentLock;

  @override
  Future<void> lock(L lock) async {
    if (_currentLock == lock) {
      return;
    } else if (_currentLock == null) {
      _currentLock = lock;
      return;
    }

    final lockCompleter = _lockCompleters.putIfAbsent(lock, () => Completer());
    await lockCompleter.future;
  }

  @override
  void unlock(L lock) {
    if (_currentLock != lock) {
      return;
    }

    final newLock = _lockCompleters.keys.firstOrNull;
    if (newLock != null) {
      _lockCompleters[newLock]!.complete();
      _lockCompleters.remove(newLock);
    }
  }
}
