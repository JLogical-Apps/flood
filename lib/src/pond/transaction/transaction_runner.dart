import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';

class TransactionRunner {
  final Transaction transaction;
  final EntityRepository repository;

  TransactionRunner({required this.transaction, required this.repository});

  Future<String> generateId(Entity entity) {
    return repository.generateId(entity, transaction: transaction);
  }

  Future<void> save(Entity entity) {
    return repository.save(entity, transaction: transaction);
  }

  Future<E?> getOrNull<E extends Entity>(String id) async {
    return await (repository.getOrNull(id, transaction: transaction)) as E?;
  }

  Future<void> delete(String id) {
    return repository.delete(id, transaction: transaction);
  }

  Future<E> get<E extends Entity>(String id) async {
    return (await repository.get(id, transaction: transaction)) as E;
  }

  Future<void> create(Entity entity) {
    return repository.create(entity, transaction: transaction);
  }

  Future<T> executeQuery<R extends Record, T>(AbstractQueryRequest<R, T> queryRequest) {
    return repository.executeQuery(queryRequest);
  }
}
