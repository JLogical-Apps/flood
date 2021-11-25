import 'package:jlogical_utils/src/pond/transaction/transaction_runner.dart';

import 'transaction_body.dart';

abstract class AbstractTransactionRunPolicy {
  Future<V> run<V>({required TransactionBody<V> body, required TransactionRunner runner});
}