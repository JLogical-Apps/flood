import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/port_drop_core.dart';
import 'package:port_drop_core/src/behavior_modifiers/value_object_field_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:runtime_type/type.dart';
import 'package:utils_core/utils_core.dart';

class ListFieldBehaviorModifier extends PortGeneratorBehaviorModifier<ListValueObjectProperty> {
  @override
  Map<String, PortField> getPortFieldByName(
    ListValueObjectProperty behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    final defaultValue =
        BehaviorMetaModifier.getModifier(context.originalBehavior)?.getDefaultValue(context.originalBehavior);

    final dropContext = context.corePondContext.dropCoreComponent;
    final runtimeType = dropContext.getRuntimeTypeOrNullRuntime(behavior.valueType);
    if (runtimeType != null && runtimeType.isA(dropContext.getRuntimeType<ValueObject>())) {
      return {
        behavior.name: PortField.list<dynamic, dynamic>(
          initialValues: behavior.value.nullIfEmpty ?? defaultValue,
          itemPortFieldGenerator: (value, fieldPath, port) {
            var valueObject = extractValueObject(context, value: value);
            valueObject ??= runtimeType.createInstanceOrNull() as ValueObject?;
            return ValueObjectFieldBehaviorModifier.getValueObjectPortField(
              context,
              initialValue: valueObject,
              isRequiredOnEdit: true,
              valueObjectType: behavior.valueType,
            )..registerToPort(fieldPath, port);
          },
          onItemRemoved: (valueObject) async {
            if (valueObject == null) {
              return;
            }

            await valueObject.onDelete(dropContext);
          },
        ),
      };
    } else {
      return {
        behavior.name: PortField.list<dynamic, dynamic>(
          initialValues: behavior.properties.nullIfEmpty ?? defaultValue,
          itemPortFieldGenerator: (propertyOrValue, fieldPath, port) {
            final property = (propertyOrValue as Object?)?.as<ValueObjectProperty>();
            var value = property == null ? propertyOrValue : property.value;

            final assetProvider = BehaviorMetaModifier.getModifier(behavior.property)?.getAssetProvider(
              context.corePondContext.assetCoreComponent,
              behavior.property,
            );
            if (assetProvider != null && value is! AssetPortValue) {
              propertyOrValue as AssetValueObjectProperty?;
              final id = switch (value) {
                String() => value,
                AssetReference() => value.id,
                AssetReferenceGetter() => value.assetId,
                _ => null,
              };
              value = AssetPortValue.initial(
                initialValue: id == null
                    ? null
                    : assetProvider.getById(
                        behavior.createAssetPathContext(context.corePondContext.assetCoreComponent),
                        id,
                      ),
                uploadedAsset: propertyOrValue?.duplicatedAsset,
              );
            }

            final itemPortModifier = PortDropCoreComponent.getBehaviorModifier(property ?? behavior.property) ??
                (throw Exception('Cannot generate port for item of property [$behavior]'));

            final itemPropertyInstance = property ?? (behavior.property.copy() as ValueObjectProperty);

            final portFieldByName = itemPortModifier.getPortFieldByName(itemPropertyInstance, context);
            if (portFieldByName.length > 1) {
              throw Exception('There are too many port fields generated for item of property [$behavior]');
            }

            return (portFieldByName.values.first..registerToPort(fieldPath, port)).copyWithValue(value);
          },
        ),
      };
    }
  }

  ValueObject? extractValueObject(PortGeneratorBehaviorModifierContext context, {required dynamic value}) {
    if (value is ValueObject) {
      return value;
    }

    if (value is StageValue) {
      final port = value.port;
      final runtimeType = value.value as RuntimeType?;
      if (port == null || runtimeType == null) {
        return null;
      }

      return context.corePortDropComponent.getValueObjectFromPort(
        port: port,
        valueObjectType: runtimeType.type,
      );
    }

    return null;
  }
}
