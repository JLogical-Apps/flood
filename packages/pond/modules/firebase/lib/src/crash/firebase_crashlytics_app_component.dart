import 'package:auth_core/auth_core.dart';
import 'package:environment/environment.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:log_core/log_core.dart';
import 'package:pond/pond.dart';

class FirebaseCrashlyticsAppComponent with IsAppPondComponent {
  @override
  Future onLoad(AppPondContext context) async {
    final firebaseComponent = context.findOrNull<FirebaseCoreComponent>();
    final shouldInitialize = firebaseComponent != null && firebaseComponent.shouldInitialize(context.environment);

    if (shouldInitialize && context.corePondContext.environmentCoreComponent.buildType == BuildType.release) {
      context.find<LogCoreComponent>().addListener(
            onLog: (message) => FirebaseCrashlytics.instance.log(message),
            onLogWarning: (message) => FirebaseCrashlytics.instance.log('[WARNING] $message'),
            onLogError: (error, stackTrace) => FirebaseCrashlytics.instance.recordError(error, stackTrace),
          );

      context.find<AuthCoreComponent>().addListener(
            onAfterLogin: (account) => FirebaseCrashlytics.instance.setUserIdentifier(account.accountId),
            onBeforeLogout: (account) => FirebaseCrashlytics.instance.setUserIdentifier('anonymous'),
          );
    }
  }
}
