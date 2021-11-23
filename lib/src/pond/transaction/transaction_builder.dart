import 'dart:async';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/transaction/one_try_transaction.dart';

import 'transaction_runner.dart';

class TransactionBuilder<V> {
  final FutureOr<V> Function(TransactionRunner transactionRunner) onExecute;

  const TransactionBuilder(this.onExecute);

  Transaction<V> build() {
    return OneTryTransaction(onExecute);
  }
}
