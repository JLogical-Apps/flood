import 'package:jlogical_utils/jlogical_utils.dart';

class AssetDeleteSyncPublishAction extends SyncPublishAction {
  late final assetIdProperty = FieldProperty(name: 'asset').required();

  @override
  Future<void> publish() async {
    // TODO
  }
}
