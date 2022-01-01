import 'package:jlogical_utils/src/model/models.dart';
import 'package:jlogical_utils/src/model/value_stream_model.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/aggregate.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/utils/stream_extensions.dart';

class AggregateController<A extends Aggregate<E>, E extends Entity> {
  final String aggregateId;

  late AsyncLoadable<A> model = ValueStreamModel<E>(
    valueX: AppContext.global.executeQueryX(_aggregateQuery).mapWithValue((maybeEntity) => maybeEntity.when(
          initial: () => FutureValue.initial(),
          loaded: (entity) => entity == null
              ? FutureValue.error(error: 'Could not load entity of type $E with id $aggregateId')
              : FutureValue.loaded(value: entity),
          error: (error) => FutureValue.error(error: error),
        )),
    loader: () async => (await AppContext.global.executeQuery<E, E?>(_aggregateQuery.withoutCache()))!,
    hasStartedLoading: true,
  ).map((entity) => AppContext.global.constructAggregateFromEntity<A>(entity));

  late final QueryRequest<E, E?> _aggregateQuery =
      Query.from<E>().where(Query.id, isEqualTo: aggregateId).firstOrNull();

  FutureValue<A> get value => model.value;

  AggregateController({required this.aggregateId});

  Future<void> reload() async {
    model.load();
  }
}
