import 'package:jlogical_utils/src/model/async_loadable.dart';
import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/model/value_stream_model.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';

class EntityController<E extends Entity> {
  final String entityId;

  late AsyncLoadable<E?> nullableModel = ValueStreamModel<E?>(
    valueX: AppContext.global.executeQueryX(_entityQuery),
    loader: () async => (await AppContext.global.executeQuery<E, E?>(_entityQuery.withoutCache()))!,
    hasStartedLoading: true,
  );

  late AsyncLoadable<E> model =
      nullableModel.map((maybeEntity) => maybeEntity ?? (throw Exception('Cannot load $E with id $entityId')));

  late final QueryRequest<E, E?> _entityQuery = Query.getById(entityId);

  FutureValue<E?> get valueOrNull => nullableModel.value;

  FutureValue<E> get value => model.value;

  EntityController({required this.entityId});

  Future<void> reload() async {
    model.load();
  }
}
