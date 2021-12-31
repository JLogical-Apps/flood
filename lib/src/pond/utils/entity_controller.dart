import 'package:jlogical_utils/src/model/async_loadable.dart';
import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/model/value_stream_model.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/utils/stream_extensions.dart';

class EntityController<E extends Entity> {
  final String entityId;

  late AsyncLoadable<E> model = ValueStreamModel<E>(
    valueX: AppContext.global.executeQueryX(_entityQuery).mapWithValue((maybeEntity) => maybeEntity.when(
          initial: () => FutureValue.initial(),
          loaded: (entity) => entity == null
              ? FutureValue.error(error: 'Could not load entity of type $E with id $entityId')
              : FutureValue.loaded(value: entity),
          error: (error) => FutureValue.error(error: error),
        )),
    loader: () async => (await AppContext.global.executeQuery<E, E?>(_entityQuery.withoutCache()))!,
    hasStartedLoading: true,
  );

  late final AbstractQueryRequest<E, E?> _entityQuery = Query.getById(entityId);

  FutureValue<E> get value => model.value;

  EntityController({required this.entityId});

  Future<void> reload() async {
    model.load();
  }
}
