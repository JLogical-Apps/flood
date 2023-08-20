import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pond/pond.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseMessagingCoreComponent with IsCorePondComponent {
  final Function()? onNotificationReceived;
  final Function(String? token)? onTokenGenerated;

  final BehaviorSubject<String?> _tokenSubject = BehaviorSubject();

  ValueStream<String?> get tokenX => _tokenSubject;
  String? get token => tokenX.value;

  FirebaseMessagingCoreComponent({this.onNotificationReceived, this.onTokenGenerated});

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onLoad: (context, component) async {
            await FirebaseMessaging.instance.requestPermission(
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
            final token = await FirebaseMessaging.instance.getToken();

            // Save the initial token to the database
            _tokenSubject.value = token;
            onTokenGenerated?.call(token);

            // Any time the token refreshes, store this in the database too.
            FirebaseMessaging.instance.onTokenRefresh.listen((token) {
              _tokenSubject.value = token;
              onTokenGenerated?.call(token);
            });
          },
        ),
      ];
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
