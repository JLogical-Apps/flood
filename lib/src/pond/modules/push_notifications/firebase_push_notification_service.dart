import 'package:firebase_messaging/firebase_messaging.dart';

import '../../context/app_context.dart';
import 'push_notification.dart';
import 'push_notification_service.dart';

class FirebasePushNotificationService extends PushNotificationService {
  final void Function(String? token) onDeviceTokenGenerated;

  FirebasePushNotificationService({required this.onDeviceTokenGenerated});

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

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    onDeviceTokenGenerated(token);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(onDeviceTokenGenerated);
  }

  @override
  Future<void> sendNotificationTo({required String to, required PushNotification notification}) async {}

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
}
