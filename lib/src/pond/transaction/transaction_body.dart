import 'dart:async';

import 'transaction_runner.dart';

class TransactionBody<V> {
  final FutureOr<V> Function(TransactionRunner runner) onExecute;

  const TransactionBody({required this.onExecute});

  Future<V> execute(TransactionRunner runner) async {
    return await onExecute(runner);
  }
}