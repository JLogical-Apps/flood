import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/behavior_wrappers/display_name_property_behavior_wrapper.dart';
import 'package:port_drop_core/src/behavior_wrappers/fallback_property_behavior_wrapper.dart';
import 'package:port_drop_core/src/behavior_wrappers/fallback_replacement_property_behavior_wrapper.dart';
import 'package:port_drop_core/src/behavior_wrappers/field_behavior_wrapper.dart';
import 'package:port_drop_core/src/behavior_wrappers/is_not_blank_property_behavior_wrapper.dart';
import 'package:port_drop_core/src/behavior_wrappers/multiline_property_behavior_wrapper.dart';
import 'package:port_drop_core/src/behavior_wrappers/required_property_behavior_wrapper.dart';
import 'package:port_drop_core/src/behavior_wrappers/string_field_behavior_wrapper.dart';
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
      RequiredPropertyBehaviorWrapper(wrapperGetter: getBehaviorWrapperOrNull),
      IsNotBlankPropertyBehaviorWrapper(wrapperGetter: getBehaviorWrapperOrNull),
      FallbackPropertyBehaviorWrapper(wrapperGetter: getBehaviorWrapperOrNull),
      FallbackReplacementPropertyBehaviorWrapper(wrapperGetter: getBehaviorWrapperOrNull),
      DisplayNamePropertyBehaviorWrapper(wrapperGetter: getBehaviorWrapperOrNull),
      MultilinePropertyBehaviorWrapper(wrapperGetter: getBehaviorWrapperOrNull),
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
    var portFieldByName = <String, PortField>{};

    for (final behavior in valueObject.behaviors) {
      final wrapper = behaviorWrapperResolver.resolveOrNull(behavior);
      if (wrapper == null) {
        continue;
      }

      final behaviorPortFieldByName = wrapper.getPortFieldByName(behavior);
      portFieldByName = {...portFieldByName, ...behaviorPortFieldByName};
    }

    return Port.of(portFieldByName).map((sourceData, port) {
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
