import 'package:jlogical_utils/jlogical_utils_core.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/modules/push_notifications/push_notification.dart';
import 'package:jlogical_utils/src/pond/modules/push_notifications/push_notification_service.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationFilterWrapperService extends PushNotificationService {
  final List<PushNotificationService> pushNotificationServices;
  final PushNotificationService Function(String to, PushNotification notification) pushNotificationServiceGetter;

  PushNotificationFilterWrapperService({
    required this.pushNotificationServices,
    required this.pushNotificationServiceGetter,
  });

  @override
  Future<void> onLoad(AppContext appContext) {
    return Future.wait(pushNotificationServices.map((service) => service.onLoad(appContext)));
  }

  @override
  void onRegister(AppRegistration registration) {
    pushNotificationServices.forEach((service) => service.onRegister(registration));
  }

  @override
  Future<void> onReset(AppContext appContext) {
    return Future.wait(pushNotificationServices.map((service) => service.onReset(appContext)));
  }

  @override
  Future<void> sendNotificationTo({required String to, required PushNotification notification}) {
    final service = pushNotificationServiceGetter(to, notification);
    return service.sendNotificationTo(to: to, notification: notification);
  }

  @override
  Stream<String?> getDeviceTokenX() {
    return Rx.merge(pushNotificationServices.map((service) => service.getDeviceTokenX()));
  }
}
