import 'dart:async';

import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/utils/synchronizable.dart';

mixin WithKeySynchronizable<L> implements Synchronizable<L> {
  Map<L, _LockCompleter> _lockCompleters = {};

  L? get _currentLock => _lockCompleters.keys.firstOrNull;

  @override
  Future<void> lock(L lock) async {
    if(_currentLock == lock) {
      return;
    }

    final currentLockCompleter = _lockCompleters[lock];
    if(currentLockCompleter != null) {
      await currentLockCompleter.future;
    }

    final lockCompleter = _LockCompleter();
    _lockCompleters[lock] = lockCompleter;

    await lockCompleter.future;
  }

  @override
  void unlock(L lock) {
    final lockCompleter = _lockCompleters[lock];
    if(lockCompleter != null) {
      lockCompleter.completer.complete();
    }

    _lockCompleters.remove(lock);
  }
}

class _LockCompleter {
  final Completer completer = Completer();

  late Future<void> future = completer.future;

  void unlock() {
    completer.complete();
  }
}
