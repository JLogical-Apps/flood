import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/type/abstract_type_implementation_repository.dart';
import 'package:pond_core/pond_core.dart';
import 'package:type/type.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

class ForAbstractTypeRepository<E extends Entity<V>, V extends ValueObject> with IsRepositoryWrapper {
  @override
  final Repository repository;

  final List<Type> entityParents;
  final List<Type> valueObjectParents;

  late RuntimeType<E> entityRuntimeType;
  late RuntimeType<V> valueObjectRuntimeType;
  late List<RuntimeType> entityParentsRuntimeTypes;
  late List<RuntimeType> valueObjectParentsRuntimeTypes;

  ForAbstractTypeRepository({
    required this.repository,
    required this.entityParents,
    required this.valueObjectParents,
  });

  @override
  List<RuntimeType> get handledTypes => repository.handledTypes + [entityRuntimeType];

  @override
  List<CorePondComponentBehavior> get behaviors =>
      repository.behaviors +
      [
        CorePondComponentBehavior(
          onRegister: (context, comp) {
            final typeComponent = context.locate<TypeCoreComponent>();
            entityRuntimeType = typeComponent.registerAbstract<E>(parents: entityParents);
            valueObjectRuntimeType = typeComponent.registerAbstract<V>(parents: valueObjectParents);
            entityParentsRuntimeTypes = entityParents.map((type) => typeComponent.getRuntimeTypeRuntime(type)).toList();
            valueObjectParentsRuntimeTypes =
                valueObjectParents.map((type) => typeComponent.getRuntimeTypeRuntime(type)).toList();
          },
        )
      ];

  AbstractTypeImplementationRepository withImplementation<E2 extends Entity<V2>, V2 extends ValueObject>(
    E2 Function() entityConstructor,
    V2 Function() valueObjectConstructor,
  ) {
    return AbstractTypeImplementationRepository<E2, V2>(
      repository: this,
      baseEntityType: E,
      baseValueObjectType: V,
      entityConstructor: entityConstructor,
      valueObjectConstructor: valueObjectConstructor,
    );
  }
}
