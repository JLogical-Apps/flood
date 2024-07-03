import 'package:asset_core/asset_core.dart';
import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/repository/device_sync_cache_repository.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:drop_core/src/sync/sync_action.dart';

class UploadAssetSyncAction extends SyncAction {
  static const assetPathField = 'assetPath';
  late final assetPathProperty = field<String>(name: assetPathField).isNotBlank();

  static const entityIdField = 'entityId';
  late final entityIdProperty = field<String>(name: entityIdField);

  static const idField = 'id';
  late final idProperty = field<String>(name: idField).isNotBlank();

  @override
  List<ValueObjectBehavior> get behaviors => [
        creationTime(),
        assetPathProperty,
        entityIdProperty,
        idProperty,
      ];

  @override
  Future<void> onPublish(DropCoreContext context) async {
    final assetCoreComponent = context.context.assetCoreComponent;
    final assetProvider = assetCoreComponent.getByAssetPath(assetPathProperty.value);
    final assetPathContext = AssetPathContext(
      context: assetCoreComponent,
      values: {State.idField: entityIdProperty.value, forceSourceUpdateField: true},
    );
    final asset = await assetProvider.getById(assetPathContext, idProperty.value).getAsset();
    await assetProvider.upload(assetPathContext, asset).timeout(Duration(seconds: 15));
  }
}
