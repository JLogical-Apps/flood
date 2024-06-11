import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:environment/environment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pond/pond.dart';

class FirebaseCoreComponent with IsCorePondComponent {
  final FirebaseOptions app;
  final String? appName;

  final bool isEmulator;
  final int firestorePort;

  final bool Function(EnvironmentType environment) shouldInitialize;

  FirebaseApp get firebaseApp => Firebase.app(appName ?? defaultFirebaseAppName);
  FirebaseFirestore get firestore => FirebaseFirestore.instanceFor(app: firebaseApp);
  FirebaseAuth get auth => FirebaseAuth.instanceFor(app: firebaseApp);
  FirebaseStorage get storage => FirebaseStorage.instanceFor(app: firebaseApp);
  FirebaseFunctions get functions => FirebaseFunctions.instanceFor(app: firebaseApp);

  FirebaseCoreComponent({
    required this.app,
    this.appName,
    this.shouldInitialize = _defaultShouldInitialize,
    this.isEmulator = false,
    this.firestorePort = 8080,
  });

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onRegister: (context, component) async {
            if (!shouldInitialize(context.environment)) {
              return;
            }

            await Firebase.initializeApp(options: app, name: appName);

            if (context.environment == EnvironmentType.static.qa) {
              final host = isEmulator ? '10.0.2.2' : 'localhost';
              firestore.settings = Settings(
                host: '$host:$firestorePort',
                sslEnabled: false,
                persistenceEnabled: false,
              );

              await auth.useAuthEmulator(host, 9099);
              await storage.useStorageEmulator(host, 9199);
              FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
            } else {
              firestore.settings = Settings(
                persistenceEnabled: false,
              );
            }
          },
        ),
      ];
}

bool _defaultShouldInitialize(EnvironmentType environment) {
  final cloudEnvironments = [
    EnvironmentType.static.qa,
    EnvironmentType.static.staging,
    EnvironmentType.static.production,
  ];

  return cloudEnvironments.contains(environment);
}
