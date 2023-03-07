import 'package:jlogical_utils/src/pond/modules/push_notifications/push_notification_filter_wrapper.dart';

import '../../context/module/app_module.dart';
import 'push_notification.dart';
import 'scheduled_notification.dart';

abstract class PushNotificationService extends AppModule {
  Future<void> sendNotificationTo({required String to, required PushNotification notification});

  Future<ScheduledNotification> scheduleNotification({
    required String to,
    required PushNotification notification,
    required DateTime date,
  });

  Stream<String?> getDeviceTokenX();

  static PushNotificationService filter({
    required List<PushNotificationService> pushNotificationServices,
    required PushNotificationService Function(String to, PushNotification notification) pushNotificationServiceGetter,
  }) {
    return PushNotificationFilterWrapperService(
      pushNotificationServices: pushNotificationServices,
      pushNotificationServiceGetter: pushNotificationServiceGetter,
    );
  }
}
