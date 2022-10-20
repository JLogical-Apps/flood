import '../../repository/adapting/default_adapting_repository.dart';
import 'push_notification_entity.dart';
import 'push_notification_record.dart';

class PushNotificationRepository extends DefaultAdaptingRepository<PushNotificationEntity, PushNotificationRecord> {
  @override
  String get dataPath => 'pushNotifications';

  @override
  PushNotificationEntity createEntity() {
    return PushNotificationEntity();
  }

  @override
  PushNotificationRecord createValueObject() {
    return PushNotificationRecord();
  }
}
