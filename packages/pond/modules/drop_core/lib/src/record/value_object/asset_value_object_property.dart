import 'package:asset_core/asset_core.dart';
import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/meta/behavior_meta_modifier.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';

class AssetValueObjectProperty
    with IsValueObjectPropertyWrapper<AssetReferenceGetter?, AssetReferenceGetter?, AssetValueObjectProperty> {
  @override
  final ValueObjectProperty<AssetReferenceGetter?, AssetReferenceGetter?, dynamic> property;

  final AssetProvider Function(AssetCoreComponent context) assetProvider;
  final AllowedFileTypes? allowedFileTypes;

  AssetValueObjectProperty({
    required this.property,
    required this.assetProvider,
    this.allowedFileTypes,
  });

  AssetValueObjectProperty.fromId({
    required ValueObjectProperty<String?, String?, ValueObjectProperty> idProperty,
    required this.assetProvider,
    this.allowedFileTypes,
  }) : property = idProperty.withMapper(
          getMapper: (assetId) => assetId == null
              ? null
              : AssetReferenceGetter(
                  id: assetId,
                  assetProviderGetter: assetProvider,
                ),
          setMapper: (assetReference) => assetReference?.id,
        );

  @override
  void fromState(DropCoreContext context, State state) {
    final stateValue = state.data[property.name];
    if (stateValue is String) {
      property.set(AssetReferenceGetter(id: stateValue, assetProviderGetter: assetProvider));
    } else if (stateValue is AssetReference) {
      property.set(AssetReferenceGetter(id: stateValue.id, assetProviderGetter: assetProvider));
    } else if (stateValue is AssetReferenceGetter) {
      property.set(stateValue);
    } else if (stateValue != null) {
      throw Exception('Unknown asset value: [$stateValue]');
    }
  }

  @override
  AssetValueObjectProperty copy() {
    return AssetValueObjectProperty(
      property: property.copy(),
      assetProvider: assetProvider,
      allowedFileTypes: allowedFileTypes,
    );
  }
}

extension AssetValueObjectPropertyExtensions<G extends AssetReferenceGetter?, S extends AssetReferenceGetter?>
    on ValueObjectProperty<G, S, dynamic> {
  AssetProvider findAssetProvider(AssetCoreComponent context) =>
      BehaviorMetaModifier.getModifier(this)?.getAssetProvider(context, this) ??
      (throw Exception('Could not find asset provider for field [$this]'));

  AssetReference? getAssetReference(AssetCoreComponent context) =>
      value == null ? null : findAssetProvider(context).getById(value!.id);
}
