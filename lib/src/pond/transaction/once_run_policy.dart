import 'package:jlogical_utils/src/pond/transaction/abstract_transaction_run_policy.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction_body.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction_runner.dart';

class OnceRunPolicy extends AbstractTransactionRunPolicy {
  @override
  Future<V> run<V>({required TransactionBody<V> body, required TransactionRunner runner}) async {
    return await body.onExecute(runner);
  }
}
