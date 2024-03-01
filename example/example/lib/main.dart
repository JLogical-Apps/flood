import 'dart:async';

import 'package:example/firebase_options.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/valet_pages_pond_component.dart';
import 'package:example/testing.dart';
import 'package:example_core/pond.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

// When setting up the test suite [testingLoggedIn] will determine whether to have the user logged in.
const testingLoggedIn = true;

Future<void> main(List<String> args) async {
  await PondApp.run(
    appPondContextGetter: buildAppPondContext,
    loadingPage: StyledLoadingPage(),
    notFoundPage: StyledPage(
      body: Center(
        child: StyledText.xl('Not Found!'),
      ),
    ),
  );
}

Future<AppPondContext> buildAppPondContext() async {
  final corePondContext = await getCorePondContext(
    environmentConfig: EnvironmentConfig.static.flutterAssets(),
    additionalCoreComponents: (corePondContext) => [
      if (corePondContext.environment.isOnline) ...[FirebaseCoreComponent(app: DefaultFirebaseOptions.currentPlatform)]
    ],
    repositoryImplementations: (corePondContext) => [
      FlutterFileRepositoryImplementation(),
      FirebaseCloudRepositoryImplementation(),
    ],
    authServiceImplementations: (corePondContext) => [FirebaseAuthServiceImplementation()],
    messagingService: (corePondContext) => corePondContext
        .environmental((type) => type.isOnline ? MessagingService.static.firebase : MessagingService.static.local()),
    taskRunner: (corePondContext) => TaskRunner.static.local,
    loggerService: (corePondContext) => corePondContext.environment.isOnline
        ? LoggerService.static.console.withFileLogHistory(corePondContext.fileSystem.tempDirectory / 'logs')
        : LoggerService.static.console,
  );

  final appPondContext = AppPondContext(corePondContext: corePondContext);
  await appPondContext.register(DebugAppComponent());
  await appPondContext.register(LogAppComponent());
  await appPondContext.register(DeviceFilesAppComponent());
  await appPondContext.register(FocusGrabberAppComponent());
  await appPondContext.register(AuthAppComponent());
  await appPondContext.register(DropAppComponent());
  await appPondContext.register(ResetAppComponent());
  await appPondContext.register(FirebaseCrashlyticsAppComponent());
  await appPondContext.register(PortStyleAppComponent());
  await appPondContext.register(StyleAppComponent(style: style));
  await appPondContext.register(UrlBarAppComponent());
  await appPondContext.register(EnvironmentBannerAppComponent());
  await appPondContext.register(ShareAppComponent());
  await appPondContext.register(TestingSetupAppComponent(onSetup: () async {
    if (testingLoggedIn) {
      await setupTesting(corePondContext);
    }
  }));
  await appPondContext.register(ValetPagesAppPondComponent());

  return appPondContext;
}
