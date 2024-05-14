import 'package:asset_core/asset_core.dart';
import 'package:drop_core/src/record/value_object/meta/behavior_meta_modifier.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';

class AssetValueObjectProperty with IsValueObjectPropertyWrapper<AssetReference?, String?, AssetValueObjectProperty> {
  @override
  final ValueObjectProperty<AssetReference?, String?, dynamic> property;

  final AssetProvider assetProvider;

  AssetValueObjectProperty({
    required this.property,
    required this.assetProvider,
  });

  AssetValueObjectProperty.fromId({
    required ValueObjectProperty<String?, String?, ValueObjectProperty> idProperty,
    required this.assetProvider,
  }) : property = idProperty.withMapper(
          getMapper: (assetId) => assetId == null ? null : assetProvider.getById(assetId),
          setMapper: (assetId) => assetId,
        );

  @override
  AssetValueObjectProperty copy() {
    return AssetValueObjectProperty(property: property.copy(), assetProvider: assetProvider);
  }
}

extension AssetValueObjectPropertyExtensions<G extends AssetReference?, S extends String?>
    on ValueObjectProperty<G, S, dynamic> {
  AssetProvider findAssetProvider() =>
      BehaviorMetaModifier.getModifier(this)?.getAssetProvider(this) ??
      (throw Exception('Could not find asset provider for field [$this]'));
}
