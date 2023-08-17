import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:environment_core/environment_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pond/pond.dart';

class FirebaseCoreComponent with IsCorePondComponent {
  final FirebaseOptions app;

  final bool isEmulator;
  final int firestorePort;

  final bool Function(EnvironmentType environment) shouldInitialize;

  FirebaseCoreComponent({
    required this.app,
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

            await Firebase.initializeApp(options: app);

            final host = isEmulator ? '10.0.2.2' : 'localhost';

            if (context.environment == EnvironmentType.static.qa) {
              FirebaseFirestore.instance.settings = Settings(
                host: '$host:$firestorePort',
                sslEnabled: false,
                persistenceEnabled: false,
              );

              await FirebaseAuth.instance.useAuthEmulator(host, 9099);
              await FirebaseStorage.instance.useStorageEmulator(host, 9199);
              FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
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
