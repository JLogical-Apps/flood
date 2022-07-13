import 'package:jlogical_utils/jlogical_utils.dart';

class AssetUploadSyncPublishAction extends SyncPublishAction {
  late final assetIdProperty = FieldProperty<String>(name: 'asset').required();

  @override
  Future<void> publish() async {
    // TODO
  }
}
