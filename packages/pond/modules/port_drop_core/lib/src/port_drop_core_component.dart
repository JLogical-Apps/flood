import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/behavior_wrappers/field_behavior_wrapper.dart';
import 'package:port_drop_core/src/behavior_wrappers/required__property_behavior_wrapper.dart';
import 'package:port_drop_core/src/behavior_wrappers/string_field_behavior_wrapper.dart';
import 'package:port_drop_core/src/behavior_wrappers/string_required__property_behavior_wrapper.dart';
import 'package:port_drop_core/src/port_generator_behavior_wrapper.dart';
import 'package:type/type.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

class PortDropCoreComponent with IsCorePondComponent {
  late final WrapperResolver<PortGeneratorBehaviorWrapper, ValueObjectBehavior> behaviorWrapperResolver =
      Resolver.fromWrappers(
    [
      StringFieldBehaviorWrapper(),
      FieldBehaviorWrapper(),
      StringRequiredPropertyBehaviorWrapper(wrapperGetter: getBehaviorWrapperOrNull),
      RequiredPropertyBehaviorWrapper(wrapperGetter: getBehaviorWrapperOrNull),
    ],
  );

  PortGeneratorBehaviorWrapper? getBehaviorWrapperOrNull(ValueObjectBehavior behavior) {
    return behaviorWrapperResolver.resolveOrNull(behavior);
  }

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior.dependency<TypeCoreComponent>(),
        CorePondComponentBehavior.dependency<DropCoreComponent>(),
      ];

  Port<V> generatePort<V extends ValueObject>(V valueObject) {
    var portValueByName = <String, PortValue>{};

    for (final behavior in valueObject.behaviors) {
      final wrapper = behaviorWrapperResolver.resolveOrNull(behavior);
      if (wrapper == null) {
        continue;
      }

      final behaviorPortFieldByName = wrapper.getPortValueByName(behavior);
      portValueByName = {...portValueByName, ...behaviorPortFieldByName};
    }

    return Port.of(portValueByName).map((sourceData, port) {
      final typeContext = context.locate<TypeCoreComponent>();
      final dropCoreContext = context.locate<DropCoreComponent>();

      final state = State.fromMap(
        sourceData,
        runtimeTypeGetter: (typeName) => typeContext.getByName(typeName),
      );
      final mergedState = valueObject.getStateUnsafe(dropCoreContext).mergeWith(state);

      final newValueObject = typeContext.constructGeneric<V>();
      newValueObject.copyFromUnsafe(dropCoreContext, mergedState);
      return newValueObject;
    });
  }
}
