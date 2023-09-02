import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:pond_core/pond_core.dart';
import 'package:type/type.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

class WithEmbeddedAbstractTypeRepository<V extends ValueObject> with IsRepositoryWrapper {
  @override
  final Repository repository;

  final String valueObjectTypeName;

  final List<Type> valueObjectParents;

  WithEmbeddedAbstractTypeRepository({
    required this.repository,
    required this.valueObjectTypeName,
    required this.valueObjectParents,
  });

  @override
  List<CorePondComponentBehavior> get behaviors =>
      repository.behaviors +
      [
        CorePondComponentBehavior(
          onRegister: (context, comp) {
            final typeComponent = context.locate<TypeCoreComponent>();
            typeComponent.registerAbstract<V>(
              name: valueObjectTypeName,
              parents: valueObjectParents,
            );
          },
        )
      ];
}
