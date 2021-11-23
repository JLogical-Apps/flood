import 'dart:async';

import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction_runner.dart';

class OneTryTransaction<V> extends Transaction<V> {
  OneTryTransaction(FutureOr<V> Function(TransactionRunner runner) onExecute) : super(onExecute);

  @override
  Future<V> onExecute(TransactionRunner runner) async {
    return body.execute(runner);
  }
}
