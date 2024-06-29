import 'package:asset_core/asset_core.dart';
import 'package:collection/collection.dart';
import 'package:drop_core/drop_core.dart';
import 'package:utils_core/utils_core.dart';

class AssetValueObjectProperty
    with IsValueObjectPropertyWrapper<AssetReferenceGetter?, AssetReferenceGetter?, AssetValueObjectProperty> {
  @override
  final ValueObjectProperty<AssetReferenceGetter?, AssetReferenceGetter?, dynamic> property;

  final AssetProvider Function(AssetCoreComponent context) assetProvider;
  final AllowedFileTypes? allowedFileTypes;

  Asset? duplicatedAsset;

  AssetValueObjectProperty({
    required this.property,
    required this.assetProvider,
    this.allowedFileTypes,
    this.duplicatedAsset,
  });

  AssetValueObjectProperty.fromId({
    required ValueObjectProperty<String?, String?, ValueObjectProperty> idProperty,
    required this.assetProvider,
    this.allowedFileTypes,
  }) : property = idProperty.withMapper(
          getMapper: (assetId) => assetId == null
              ? null
              : AssetReferenceGetter(
                  assetId: assetId,
                  pathContextGetter: (context) => idProperty.createAssetPathContext(context),
                  assetProviderGetter: assetProvider,
                ),
          setMapper: (assetReference) => assetReference?.assetId,
        );

  @override
  void fromState(DropCoreContext context, State state) {
    final stateValue = state.data[property.name];
    if (stateValue is String) {
      property.set(AssetReferenceGetter(
        assetId: stateValue,
        pathContextGetter: (context) => createAssetPathContext(context),
        assetProviderGetter: assetProvider,
      ));
    } else if (stateValue is AssetReference) {
      property.set(AssetReferenceGetter(
        assetId: stateValue.id,
        pathContextGetter: (context) => createAssetPathContext(context),
        assetProviderGetter: assetProvider,
      ));
    } else if (stateValue is AssetReferenceGetter) {
      property.set(stateValue);
    } else if (stateValue != null) {
      throw Exception('Unknown asset value: [$stateValue]');
    }

    duplicatedAsset = state.metadata[property.name];
  }

  @override
  State modifyState(DropCoreContext context, State state) {
    state = state.withMetadata(state.metadata.copy()..set(property.name, duplicatedAsset));
    return super.modifyState(context, state);
  }

  @override
  Future<void> onDuplicateTo(DropCoreContext context, AssetValueObjectProperty property) async {
    // Instead of containing the same asset as the source, copy the asset and use that instead.
    // This issues with the original asset being deleted.
    if (value?.assetId != null) {
      final asset = await assetProvider(context.context.assetCoreComponent)
          .getById(createAssetPathContext(context.context.assetCoreComponent), value!.assetId)
          .getAsset();
      property.set(null);
      property.duplicatedAsset = asset.withNewId();
    }
  }

  @override
  Future<void> onDelete(DropCoreContext context) async {
    if (value?.assetId != null) {
      await guardAsync(() => assetProvider(context.context.assetCoreComponent)
          .delete(createAssetPathContext(context.context.assetCoreComponent), value!.assetId));
    }
  }

  @override
  Future<void> onBeforeSave(DropCoreContext context) async {
    if (duplicatedAsset != null) {
      final asset = await guardAsync(() => assetProvider(context.context.assetCoreComponent)
          .upload(createAssetPathContext(context.context.assetCoreComponent), duplicatedAsset!));
      if (asset != null) {
        set(AssetReferenceGetter(
          assetId: asset.id,
          pathContextGetter: (context) => createAssetPathContext(context),
          assetProviderGetter: assetProvider,
        ));
      }
      duplicatedAsset = null;
    }
  }

  @override
  AssetValueObjectProperty copy() {
    return AssetValueObjectProperty(
      property: property.copy(),
      assetProvider: assetProvider,
      allowedFileTypes: allowedFileTypes,
      duplicatedAsset: duplicatedAsset,
    );
  }
}

extension AssetValueObjectPropertyExtensions<G extends AssetReferenceGetter?, S extends AssetReferenceGetter?>
    on ValueObjectProperty<G, S, dynamic> {
  AssetProvider findAssetProvider(AssetCoreComponent context) =>
      BehaviorMetaModifier.getModifier(this)?.getAssetProvider(context, this) ??
      (throw Exception('Could not find asset provider for field [$this]'));

  AssetReference? getAssetReference(AssetCoreComponent context) => value == null
      ? null
      : findAssetProvider(context).getById(valueObject.createAssetPathContext(context), value!.assetId);

  Future<Asset> uploadAsset(AssetCoreComponent context, Asset asset) async {
    final dropContext = context.context.dropCoreComponent;
    final assetPathContext = valueObject.createAssetPathContext(context);
    final assetProvider = findAssetProvider(context);
    if (value != null) {
      await guardAsync(() => assetProvider.delete(assetPathContext, value!.assetId));
    }
    final uploadedAsset = await assetProvider.upload(assetPathContext, asset);
    await dropContext.updateEntity(
      valueObject.entity!,
      (ValueObject valueObject) {
        final state = valueObject.getState(dropContext);
        valueObject.setState(dropContext, state.withData(state.data.copy()..set(name, uploadedAsset.id)));
      },
    );
    return uploadedAsset;
  }

  Future<void> deleteAsset(AssetCoreComponent context) async {
    final dropContext = context.context.dropCoreComponent;
    final assetProvider = findAssetProvider(context);
    final assetPathContext = valueObject.createAssetPathContext(context);
    if (value == null) {
      throw Exception('Cannot delete asset when no asset id is in the property!');
    }

    await assetProvider.delete(assetPathContext, value!.assetId);
    await dropContext.updateEntity(
      valueObject.entity!,
      (ValueObject valueObject) {
        final state = valueObject.getState(dropContext);
        valueObject.setState(dropContext, state.withData(state.data.copy()..set(name, null)));
      },
    );
  }
}

extension AssetListValueObjectPropertyExtensions
    on ValueObjectProperty<List<AssetReferenceGetter>, List<AssetReferenceGetter>, dynamic> {
  AssetProvider findAssetProvider(AssetCoreComponent context) =>
      BehaviorMetaModifier.getModifier(this)?.getAssetProvider(context, this) ??
      (throw Exception('Could not find asset provider for field [$this]'));

  Future<Asset> uploadAsset(AssetCoreComponent context, Asset asset) async {
    final dropContext = context.context.dropCoreComponent;
    final assetPathContext = valueObject.createAssetPathContext(context);
    final assetProvider = findAssetProvider(context);

    final uploadedAsset = await assetProvider.upload(assetPathContext, asset);
    await dropContext.updateEntity(
      valueObject.entity!,
      (ValueObject valueObject) {
        final state = valueObject.getState(dropContext);
        valueObject.setState(dropContext, state.withData(state.data.copy()..set(name, [...value, uploadedAsset.id])));
      },
    );
    return uploadedAsset;
  }

  Future<void> deleteAsset(AssetCoreComponent context, String assetId) async {
    final dropContext = context.context.dropCoreComponent;
    final assetProvider = findAssetProvider(context);
    final assetPathContext = valueObject.createAssetPathContext(context);

    if (value.none((reference) => reference.assetId == assetId)) {
      throw Exception('Cannot delete asset when no asset with id [$assetId] is in the list!');
    }

    await assetProvider.delete(assetPathContext, assetId);
    await dropContext.updateEntity(
      valueObject.entity!,
      (ValueObject valueObject) {
        final state = valueObject.getState(dropContext);
        valueObject.setState(
            dropContext,
            state.withData(state.data.copy()
              ..set(
                name,
                value.where((reference) => reference.assetId != assetId).toList(),
              )));
      },
    );
  }
}

extension AssetPathContextPropertyExtensions on AssetPathContext {
  String? get entityId => values[State.idField];
}
