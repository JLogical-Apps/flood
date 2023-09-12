import 'package:environment/environment.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pond/pond.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils/utils.dart';

class FirebaseMessagingAppComponent with IsAppPondComponent {
  final Function()? onNotificationReceived;
  final Function(String? token)? onTokenGenerated;

  final BehaviorSubject<FutureValue<String?>> _tokenSubject = BehaviorSubject.seeded(FutureValue.empty());

  ValueStream<FutureValue<String?>> get tokenX => _tokenSubject;

  String? get token => tokenX.value.getOrNull();

  FirebaseMessagingAppComponent({this.onNotificationReceived, this.onTokenGenerated});

  @override
  Future onLoad(AppPondContext context) async {
    final firebaseCoreComponent = context.findOrNull<FirebaseCoreComponent>();
    if (firebaseCoreComponent == null) {
      return;
    }

    if (!firebaseCoreComponent.shouldInitialize(context.environment)) {
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

      FirebaseMessaging.onMessage.listen((message) => onNotificationReceived?.call());
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Get the token each time the application loads
      final token = await FirebaseMessaging.instance.getToken();

      // Save the initial token to the database
      _tokenSubject.value = FutureValue.loaded(token);
      onTokenGenerated?.call(token);

      // Any time the token refreshes, store this in the database too.
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        _tokenSubject.value = FutureValue.loaded(token);
        onTokenGenerated?.call(token);
      });
    }();
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
