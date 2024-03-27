import 'dart:async';

import 'package:example/firebase_options.dart';
import 'package:example/presentation/pages_pond_component.dart';
import 'package:example/presentation/style.dart';
import 'package:example/testing.dart';
import 'package:example_core/pond.dart';
import 'package:flood/flood.dart';
import 'package:flutter/material.dart';

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
    initialCoreComponents: (corePondContext) => [
      if (corePondContext.environment.isOnline) ...[FirebaseCoreComponent(app: DefaultFirebaseOptions.currentPlatform)]
    ],
    repositoryImplementations: (corePondContext) => [
      FlutterFileRepositoryImplementation(),
      FirebaseCloudRepositoryImplementation(),
    ],
    authServiceImplementations: (corePondContext) => [FirebaseAuthServiceImplementation()],
    messagingService: (corePondContext) => corePondContext
        .environmental((type) => type.isOnline ? MessagingService.static.firebase : MessagingService.static.local()),
    loggerService: (corePondContext) => corePondContext.environment.isOnline
        ? LoggerService.static.console.withFileLogHistory(corePondContext.fileSystem.tempDirectory / 'logs')
        : LoggerService.static.console,
  );

  final appPondContext = AppPondContext(corePondContext: corePondContext);
  await appPondContext.register(FloodAppComponent(style: style));
  await appPondContext.register(TestingSetupAppComponent(onSetup: () async {
    final testingSetup = await corePondContext.environmentConfig.getOrDefault('testingSetup', fallback: () => false);
    if (testingSetup) {
      await setupTesting(corePondContext);
    }
  }));
  await appPondContext.register(PagesPondComponent());

  return appPondContext;
}
