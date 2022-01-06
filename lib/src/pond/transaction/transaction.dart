import 'dart:async';

import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/transaction/abstract_transaction_run_policy.dart';
import 'package:jlogical_utils/src/pond/transaction/once_run_policy.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction_body.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction_executor.dart';

import 'transaction_runner.dart';

class Transaction<V> {
  final TransactionBody<V> body;
  final AbstractTransactionRunPolicy runPolicy;

  Transaction(FutureOr<V> onExecute(TransactionRunner runner), {AbstractTransactionRunPolicy? runPolicy})
      : body = TransactionBody<V>(onExecute: onExecute),
        this.runPolicy = runPolicy ?? OnceRunPolicy();

  Future<V> execute<E extends Entity>() {
    return AppContext.global.getRepository<E>().executeTransaction(this);
  }

  Future<V> onExecute(EntityRepository repository) {
    final transactionRunner = TransactionRunner(transaction: this, repository: repository);
    return runPolicy.run(body: body, runner: transactionRunner);
  }
}
