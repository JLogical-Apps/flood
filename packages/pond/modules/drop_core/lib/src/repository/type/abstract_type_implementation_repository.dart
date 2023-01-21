import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:pond_core/pond_core.dart';
import 'package:type/type.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

class AbstractTypeImplementationRepository<E extends Entity<V>, V extends ValueObject> with IsRepositoryWrapper {
  @override
  final Repository repository;

  final Type baseEntityType;
  final Type baseValueObjectType;

  final E Function() entityConstructor;
  final V Function() valueObjectConstructor;

  final String entityTypeName;
  final String valueObjectTypeName;

  late RuntimeType<E> entityRuntimeType;
  late RuntimeType<V> valueObjectRuntimeType;

  AbstractTypeImplementationRepository({
    required this.repository,
    required this.baseEntityType,
    required this.baseValueObjectType,
    required this.entityConstructor,
    required this.valueObjectConstructor,
    required this.entityTypeName,
    required this.valueObjectTypeName,
  });

  @override
  List<CorePondComponentBehavior> get behaviors =>
      repository.behaviors +
      [
        CorePondComponentBehavior(
          onRegister: (context, comp) {
            final typeComponent = context.locate<TypeCoreComponent>();
            entityRuntimeType = typeComponent.register<E>(
              entityConstructor,
              name: entityTypeName,
              parents: [baseEntityType],
            );
            valueObjectRuntimeType = typeComponent.register<V>(
              valueObjectConstructor,
              name: valueObjectTypeName,
              parents: [baseValueObjectType],
            );
          },
        )
      ];

  AbstractTypeImplementationRepository withImplementation<E2 extends Entity<V2>, V2 extends ValueObject>(
    E2 Function() entityConstructor,
    V2 Function() valueObjectConstructor, {
    required String entityTypeName,
    required String valueObjectTypeName,
  }) {
    return AbstractTypeImplementationRepository<E2, V2>(
      repository: this,
      baseEntityType: baseEntityType,
      baseValueObjectType: baseValueObjectType,
      entityTypeName: entityTypeName,
      valueObjectTypeName: valueObjectTypeName,
      entityConstructor: entityConstructor,
      valueObjectConstructor: valueObjectConstructor,
    );
  }

  @override
  RepositoryQueryExecutor get queryExecutor => repository.queryExecutor.withHandledTypes([entityRuntimeType]);
}
