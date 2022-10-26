import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/modules/environment/environment_module.dart';

import '../environment/environment.dart';

class FirebaseModule extends AppModule {
  final FirebaseOptions app;

  FirebaseModule._({required this.app});

  static Future<FirebaseModule> create({
    required FirebaseOptions app,
    bool forceInitialize: false,
    bool isEmulator: false,
  }) async {
    final module = FirebaseModule._(app: app);

    if (forceInitialize || AppContext.global.environment.index >= Environment.qa.index) {
      await Firebase.initializeApp(options: app);
    }

    final host = isEmulator ? '10.0.2.2' : 'localhost';

    if (AppContext.global.environment == Environment.qa) {
      FirebaseFirestore.instance.settings = Settings(
        host: '$host:8080',
        sslEnabled: false,
        persistenceEnabled: false,
      );

      await FirebaseAuth.instance.useAuthEmulator(host, 9099);

      await FirebaseStorage.instance.useStorageEmulator(host, 9199);
    }

    return module;
  }

  @override
  Future<void> onReset(AppContext context) async {
    // Initialize it so that other Firebase-related services can reset without error.
    if (context.environment.index >= Environment.qa.index) {
      await Firebase.initializeApp(options: app);
    }
  }
}
