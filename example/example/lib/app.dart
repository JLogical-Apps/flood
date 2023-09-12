import 'dart:async';

import 'package:example/firebase_options.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/port/envelope_port_override.dart';
import 'package:example/presentation/port/envelope_transaction_port_override.dart';
import 'package:example/presentation/port/repeating_goal_port_override.dart';
import 'package:example/presentation/port/transfer_transaction_port_override.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/valet_pages_pond_component.dart';
import 'package:example/testing.dart';
import 'package:example_core/features/user/user.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:example_core/pond.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

// When setting up the test suite [testingLoggedIn] will determine whether to have the user logged in.
const testingLoggedIn = true;

Future<void> main(List<String> args) async {
  await PondApp.run(
    appPondContextGetter: () async => await getAppPondContext(await getCorePondContext(
      environmentConfig: EnvironmentConfig.static.flutterAssets(),
      additionalCoreComponents: (context) => [
        FirebaseCoreComponent(app: DefaultFirebaseOptions.currentPlatform),
        FirebaseMessagingCoreComponent(
          onTokenGenerated: (token) async {
            final loggedInUserId = context.locate<AuthCoreComponent>().loggedInUserId;
            if (loggedInUserId == null) {
              return;
            }

            final userEntity = await Query.getByIdOrNull<UserEntity>(loggedInUserId).get(context.dropCoreComponent);
            if (userEntity == null) {
              return;
            }

            await context.dropCoreComponent.updateEntity(
              userEntity,
              (User user) => user..deviceTokenProperty.set(token),
            );
          },
        ),
      ],
      repositoryImplementations: [
        FlutterFileRepositoryImplementation(),
        FirebaseCloudRepositoryImplementation(),
      ],
      authServiceImplementations: [
        FirebaseAuthServiceImplementation(),
      ],
      onAfterLogin: (context, userId) async {
        final token = context.locate<FirebaseMessagingCoreComponent>().token;

        final userEntity = await Query.getByIdOrNull<UserEntity>(userId).get(context.dropCoreComponent);
        if (userEntity == null) {
          return;
        }

        await context.dropCoreComponent.updateEntity(userEntity, (User user) => user..deviceTokenProperty.set(token));
      },
      onBeforeLogout: (context, userId) async {
        final userEntity = await Query.getByIdOrNull<UserEntity>(userId).get(context.dropCoreComponent);
        if (userEntity == null) {
          return;
        }

        await context.dropCoreComponent.updateEntity(userEntity, (User user) => user..deviceTokenProperty.set(null));
      },
    )),
    splashPage: StyledPage(
      body: Center(
        child: StyledLoadingIndicator(),
      ),
    ),
    notFoundPage: StyledPage(
      body: Center(
        child: StyledText.h1('Not Found!'),
      ),
    ),
    initialPageGetter: () => HomePage(),
    onError: (appPondContext, error, stackTrace) {
      if (appPondContext == null) {
        print(error);
        print(stackTrace);
      } else {
        appPondContext.find<LogCoreComponent>().logError(error, stackTrace);
      }
    },
  );
}

Future<AppPondContext> getAppPondContext(CorePondContext corePondContext) async {
  final appPondContext = AppPondContext(corePondContext: corePondContext);
  await appPondContext.register(NavigationAppComponent());
  await appPondContext.register(DebugAppComponent());
  await appPondContext.register(LogAppComponent());
  await appPondContext.register(DeviceFilesAppComponent());
  await appPondContext.register(FocusGrabberAppComponent());
  await appPondContext.register(AuthAppComponent());
  await appPondContext.register(DropAppComponent());
  await appPondContext.register(ResetAppComponent());
  await appPondContext.register(PortStyleAppComponent(overrides: [
    EnvelopePortOverride(context: appPondContext),
    EnvelopeTransactionPortOverride(context: appPondContext),
    TransferTransactionPortOverride(context: appPondContext),
    RepeatingGoalPortOverride(context: appPondContext),
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
