import 'package:drop/drop.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';
import 'package:utils/utils.dart';

SyncState useSyncState() {
  final syncCoreComponent = useContext().corePondContext.syncCoreComponent;
  return useValueStream(syncCoreComponent.syncStateX);
}
