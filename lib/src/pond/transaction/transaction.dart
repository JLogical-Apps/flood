import 'dart:async';

import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/transaction/abstract_transaction_run_policy.dart';
import 'package:jlogical_utils/src/pond/transaction/once_run_policy.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction_body.dart';

import 'transaction_runner.dart';

class Transaction<V> {
  final TransactionBody<V> body;
  final AbstractTransactionRunPolicy runPolicy;

  Transaction(FutureOr<V> onExecute(TransactionRunner runner), {AbstractTransactionRunPolicy? runPolicy})
      : body = TransactionBody<V>(onExecute: onExecute),
        this.runPolicy = runPolicy ?? OnceRunPolicy();

  Future<V> onExecute(EntityRepository repository) {
    final transactionRunner = TransactionRunner(transaction: this, repository: repository);
    return runPolicy.run(body: body, runner: transactionRunner);
  }
}
