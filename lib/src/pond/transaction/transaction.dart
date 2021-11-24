import 'dart:async';

import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction_body.dart';

import 'transaction_runner.dart';

class Transaction<V> {
  final TransactionBody<V> body;

  Transaction(FutureOr<V> onExecute(TransactionRunner runner)) : body = TransactionBody<V>(onExecute: onExecute);

  Future<V> execute(EntityRepository repository) async {
    final transactionRunner = TransactionRunner(transaction: this, repository: repository);
    return onExecute(transactionRunner);
  }

  Future<V> onExecute(TransactionRunner runner) {
    return body.execute(runner);
  }
}
