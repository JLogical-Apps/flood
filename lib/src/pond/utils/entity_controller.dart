import 'package:jlogical_utils/src/model/async_loadable.dart';
import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/model/value_stream_model.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/utils/stream_extensions.dart';

class EntityController<E extends Entity> {
  final String entityId;

  late AsyncLoadable<E?> nullableModel = ValueStreamModel<E?>(
    valueX: AppContext.global
        .getRepositoryRuntimeOrNull(E)!
        .getXOrNull(entityId)
        .mapWithValue((maybeEntity) => maybeEntity.mapIfPresent((entity) => entity as E)),
    loader: () async => (await AppContext.global.getRepositoryRuntimeOrNull(E)!.get(entityId, withoutCache: true)) as E,
    hasStartedLoading: true,
  );

  late AsyncLoadable<E> model =
      nullableModel.map((maybeEntity) => maybeEntity ?? (throw Exception('Cannot load $E with id $entityId')));

  FutureValue<E?> get valueOrNull => model.value;

  FutureValue<E> get value =>
      valueOrNull.mapIfPresent((value) => value ?? (throw Exception('Cannot get value of $E with id $entityId')));

  EntityController({required this.entityId});

  Future<void> reload() async {
    model.load();
  }
}
