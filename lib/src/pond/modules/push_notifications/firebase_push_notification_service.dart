import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jlogical_utils/src/pond/modules/push_notifications/push_notification_entity.dart';
import 'package:jlogical_utils/src/pond/modules/push_notifications/push_notification_record.dart';
import 'package:jlogical_utils/src/pond/modules/push_notifications/scheduled_notification.dart';
import 'package:rxdart/rxdart.dart';

import '../../context/app_context.dart';
import 'push_notification.dart';
import 'push_notification_service.dart';

class FirebasePushNotificationService extends PushNotificationService {
  final void Function()? onNotificationReceived;

  FirebasePushNotificationService({this.onNotificationReceived});

  final BehaviorSubject<String?> _tokenSubject = BehaviorSubject();

  @override
  Future<void> onLoad(AppContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) => onNotificationReceived?.call());
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    _tokenSubject.value = token;

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen((token) => _tokenSubject.value = token);
  }

  @override
  Future<void> sendNotificationTo({required String to, required PushNotification notification}) async {
    final record = PushNotificationRecord.fromPushNotification(to: to, pushNotification: notification);
    final entity = PushNotificationEntity()..value = record;
    await entity.create();
  }

  @override
  Stream<String?> getDeviceTokenX() {
    return _tokenSubject;
  }

  @override
  Future<ScheduledNotification> scheduleNotification({
    required String to,
    required PushNotification notification,
    required DateTime date,
  }) {
    throw Exception('You cannot schedule notifications with Firebase!');
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
