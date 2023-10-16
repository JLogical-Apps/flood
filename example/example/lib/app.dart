import 'dart:async';

import 'package:example/firebase_options.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/port/envelope_styled_port_override.dart';
import 'package:example/presentation/port/envelope_styled_transaction_port_override.dart';
import 'package:example/presentation/port/repeating_goal_styled_port_override.dart';
import 'package:example/presentation/port/transfer_transaction_styled_port_override.dart';
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
    appPondContextGetter: () =>
        buildLateAsync<AppPondContext>((appPondContextGetter) async => await getAppPondContext(await getCorePondContext(
              environmentConfig: EnvironmentConfig.static.flutterAssets(),
              additionalCoreComponents: [
                FirebaseCoreComponent(app: DefaultFirebaseOptions.currentPlatform),
                AppwriteCoreComponent(
                  config: AppwriteConfig.localhost(projectId: '651b48116fc13fcb79be'),
                ),
              ],
              repositoryImplementations: [
                FlutterFileRepositoryImplementation(),
                AppwriteCloudRepositoryImplementation(),
              ],
              messagingService: MessagingService.static.environmental((environment) {
                final environmentType = environment.environment;
                if (environmentType == EnvironmentType.static.testing ||
                    environmentType == EnvironmentType.static.device) {
                  return MessagingService.static.local(refreshDuration: Duration(minutes: 5));
                }

                return MessagingService.static.firebase;
              }),
              authServiceImplementations: [
                AppwriteAuthServiceImplementation(),
              ],
            ))),
    loadingPage: StyledPage(
      body: Center(
        child: StyledLoadingIndicator(),
      ),
    ),
    notFoundPage: StyledPage(
      body: Center(
        child: StyledText.h1('Not Found!'),
      ),
    ),
    initialRouteGetter: () => HomeRoute(),
  );
}

Future<AppPondContext> getAppPondContext(CorePondContext corePondContext) async {
  final appPondContext = AppPondContext(corePondContext: corePondContext);
  await appPondContext.register(DebugAppComponent());
  await appPondContext.register(LogAppComponent());
  await appPondContext.register(DeviceFilesAppComponent());
  await appPondContext.register(FocusGrabberAppComponent());
  await appPondContext.register(AuthAppComponent());
  await appPondContext.register(DropAppComponent());
  await appPondContext.register(ResetAppComponent());
  await appPondContext.register(PortStyleAppComponent(overrides: [
    EnvelopeStyledPortOverride(context: appPondContext),
    EnvelopeTransactionStyledPortOverride(context: appPondContext),
    TransferTransactionStyledPortOverride(context: appPondContext),
    RepeatingGoalStyledPortOverride(context: appPondContext),
  ]));
  await appPondContext.register(StyleAppComponent(style: style));
  await appPondContext.register(UrlBarAppComponent());
  await appPondContext.register(EnvironmentBannerAppComponent());
  await appPondContext.register(TestingSetupAppComponent(onSetup: () async {
    if (testingLoggedIn) {
      await setupTesting(corePondContext);
    }
  }));
  await appPondContext.register(ValetPagesAppPondComponent());

  return appPondContext;
}
