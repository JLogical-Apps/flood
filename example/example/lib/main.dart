import 'dart:async';

import 'package:example/firebase_options.dart';
import 'package:example/presentation/pages_pond_component.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/utils/redirect_utils.dart';
import 'package:example/testing.dart';
import 'package:example_core/features/public_settings/public_settings_entity.dart';
import 'package:example_core/pond.dart';
import 'package:flood/flood.dart' as flood;
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
    appPageWrapper: <R extends flood.Route>(AppPage<R> appPage) => appPage.checkIfOutdated(),
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

  final latestAllowedVersionDataSource = corePondContext.environmental((type) => type.isOnline
      ? DataSource.static
          .firestoreDocumentEntity<PublicSettingsEntity>(
            'public/public',
            context: corePondContext.dropCoreComponent,
          )
          .mapGet((publicSettingsEntity) => publicSettingsEntity.value.minVersionProperty.value)
          .withCache(CachePolicy.timed(Duration(minutes: 10)))
      : null);

  final appPondContext = AppPondContext(corePondContext: corePondContext);
  await appPondContext.register(FloodAppComponent(
    style: style,
    latestAllowedVersion: () async {
      final rawVersion = await latestAllowedVersionDataSource?.getOrNull();
      return rawVersion?.mapIfNonNull((value) => Version.parse(value));
    },
  ));
  await appPondContext.register(TestingSetupAppComponent(onSetup: () async {
    final testingSetup = await corePondContext.environmentConfig.getOrDefault('testingSetup', fallback: () => true);
    if (testingSetup) {
      await setupTesting(corePondContext);
    }
  }));
  await appPondContext.register(PagesPondComponent());

  return appPondContext;
}
