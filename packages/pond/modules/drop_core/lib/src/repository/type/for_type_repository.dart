import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:pond_core/pond_core.dart';
import 'package:runtime_type/type.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

class ForTypeRepository<E extends Entity<V>, V extends ValueObject> with IsRepository {
  final E Function() entityConstructor;
  final V Function() valueObjectConstructor;

  final String entityTypeName;
  final String valueObjectTypeName;

  final List<Type> entityParents;
  final List<Type> valueObjectParents;

  late RuntimeType<E> entityRuntimeType;
  late RuntimeType<V> valueObjectRuntimeType;
  late List<RuntimeType> entityParentsRuntimeTypes;
  late List<RuntimeType> valueObjectParentsRuntimeTypes;

  ForTypeRepository({
    required this.entityConstructor,
    required this.valueObjectConstructor,
    required this.entityTypeName,
    required this.valueObjectTypeName,
    required this.entityParents,
    required this.valueObjectParents,
  });

  @override
  List<RuntimeType> get handledTypes => [entityRuntimeType];

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onRegister: (context, comp) {
            final typeComponent = context.locate<TypeCoreComponent>();
            entityRuntimeType = typeComponent.register<E>(
              entityConstructor,
              name: entityTypeName,
              parents: [...entityParents, Entity],
            );
            valueObjectRuntimeType = typeComponent.register<V>(
              valueObjectConstructor,
              name: valueObjectTypeName,
              parents: [...valueObjectParents, ValueObject],
            );
            entityParentsRuntimeTypes = entityParents.map((type) => typeComponent.getRuntimeTypeRuntime(type)).toList();
            valueObjectParentsRuntimeTypes =
                valueObjectParents.map((type) => typeComponent.getRuntimeTypeRuntime(type)).toList();
          },
        )
      ];

  @override
  RepositoryQueryExecutor get queryExecutor => throw UnimplementedError();

  @override
  RepositoryStateHandler get stateHandler => throw UnimplementedError();
}
