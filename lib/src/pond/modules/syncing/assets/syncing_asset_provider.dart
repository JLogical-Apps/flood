import 'package:jlogical_utils/src/pond/modules/syncing/syncing_module.dart';

import '../../../../persistence/export_core.dart';
import '../../../context/app_context.dart';
import '../../asset/asset.dart';
import '../../asset/asset_provider.dart';

/// Connects an asset provider to the syncing system so pending uploads are uploaded.
class SyncingAssetProvider extends AssetProvider {
  final AssetProvider localAssetProvider;

  final AssetProvider sourceAssetProvider;

  SyncingAssetProvider({required this.localAssetProvider, required this.sourceAssetProvider});

  @override
  DataSource<Asset> getDataSource(String id) {
    return _SyncingDataSource(localDataSource: localAssetProvider.getDataSource(id));
  }
}

/// DataSource that enqueues publish actions to the syncing module.
class _SyncingDataSource extends DataSource<Asset> {
  final DataSource<Asset> localDataSource;

  late final SyncingModule syncingModule = locate<SyncingModule>();

  _SyncingDataSource({required this.localDataSource});

  @override
  Future<void> delete() async {
    // TODO await syncingModule.enqueueSyncPublishAction(action);
    await localDataSource.delete();
  }

  @override
  Future<Asset?> getData() {
    return localDataSource.getData();
  }

  @override
  Future<void> saveData(Asset data) async {
    // TODO await syncingModule.enqueueSyncPublishAction(action);
    await localDataSource.saveData(data);
  }
}
