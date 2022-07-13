import '../../../record/value_object.dart';

abstract class SyncPublishAction extends ValueObject {
  /// Action to perform when publishing this sync action to a source repository.
  Future<void> publish();
}