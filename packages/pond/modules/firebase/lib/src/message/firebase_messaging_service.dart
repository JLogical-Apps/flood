import 'package:environment/environment.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:messaging_core/messaging_core.dart';
import 'package:pond/pond.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils/utils.dart';

class FirebaseMessagingService with IsMessagingService, IsCorePondComponent {
  final BehaviorSubject<DataMessage> _dataMessageSubject = BehaviorSubject();
  final BehaviorSubject<NotificationMessage> _notificationMessageSubject = BehaviorSubject();
  final BehaviorSubject<FutureValue<String?>> _deviceTokenSubject = BehaviorSubject.seeded(FutureValue.empty());

  @override
  Stream<DataMessage> get dataMessageX => _dataMessageSubject;

  @override
  ValueStream<FutureValue<String?>> get deviceTokenX => _deviceTokenSubject;

  @override
  Stream<NotificationMessage> get notificationMessageX => _notificationMessageSubject;

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onLoad: (context, _) async {
            final firebaseCoreComponent = context.locateOrNull<FirebaseCoreComponent>();
            if (firebaseCoreComponent == null) {
              return;
            }

            if (!firebaseCoreComponent.shouldInitialize(context.environment) ||
                context.environmentCoreComponent.platform != Platform.mobile) {
              return;
            }

            () async {
              await FirebaseMessaging.instance.requestPermission(
                alert: true,
                announcement: true,
                badge: true,
                carPlay: true,
                criticalAlert: false,
                provisional: false,
                sound: true,
              );

              FirebaseMessaging.onMessage.listen((message) {
                if (message.notification != null) {
                  _notificationMessageSubject.value = NotificationMessage(
                    title: message.notification!.title ?? 'N/A',
                    body: message.notification!.body,
                    data: message.data,
                  );
                } else {
                  _dataMessageSubject.value = DataMessage(data: message.data);
                }
              });
              FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

              // Get the token each time the application loads
              final token = await FirebaseMessaging.instance.getToken();

              // Save the initial token to the database
              _deviceTokenSubject.value = FutureValue.loaded(token);

              // Any time the token refreshes, store this in the database too.
              FirebaseMessaging.instance.onTokenRefresh
                  .listen((token) => _deviceTokenSubject.value = FutureValue.loaded(token));
            }();
          },
        )
      ];

  @override
  Future<void> onSendDataMessage(DataMessage message, String toDeviceToken) {
    throw UnimplementedError();
  }

  @override
  Future<void> onSendNotificationMessage(NotificationMessage message, String toDeviceToken) {
    throw UnimplementedError();
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

extension FirebaseMessagingServiceStaticExtensions on MessagingServiceStatic {
  MessagingService get firebase => FirebaseMessagingService();
}
