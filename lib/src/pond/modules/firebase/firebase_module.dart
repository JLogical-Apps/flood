import 'package:firebase_core/firebase_core.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/module/app_module.dart';

class FirebaseModule extends AppModule {
  final FirebaseOptions app;

  FirebaseModule({required this.app});

  @override
  Future<void> onLoad(AppContext context) async {
    await Firebase.initializeApp(options: app);
  }

  @override
  Future<void> onReset(AppContext context) async {
    // Initialize it so that other Firebase-related services can reset without error.
    await Firebase.initializeApp(options: app);
  }
}
