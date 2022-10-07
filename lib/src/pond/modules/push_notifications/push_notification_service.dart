import '../../context/module/app_module.dart';
import 'push_notification.dart';

abstract class PushNotificationService extends AppModule {
  Future<void> sendNotificationTo({required String to, required PushNotification notification});
}
