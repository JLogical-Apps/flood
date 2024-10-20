import 'dart:async';

import 'package:example_core/components/testing_utility_component.dart';
import 'package:example_core/features/local_settings/local_settings_repository.dart';
import 'package:example_core/features/public_settings/public_settings_repository.dart';
import 'package:example_core/features/tag/tag_repository.dart';
import 'package:example_core/features/todo/todo.dart';
import 'package:example_core/features/todo/todo_repository.dart';
import 'package:example_core/features/user/user.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:example_core/features/user/user_repository.dart';
import 'package:example_core/features/user/user_token.dart';
import 'package:flood_core/flood_core.dart';

Future<CorePondContext> getCorePondContext({
  EnvironmentConfig? environmentConfig,
  FutureOr<List<CorePondComponent>> Function(CorePondContext context)? initialCoreComponents,
  List<RepositoryImplementation> Function(CorePondContext context)? repositoryImplementations,
  List<AuthServiceImplementation> Function(CorePondContext context)? authServiceImplementations,
  List<AssetProviderImplementation> Function(CorePondContext context)? assetProviderImplementations,
  MessagingService? Function(CorePondContext context)? messagingService,
  LoggerService? Function(CorePondContext context)? loggerService,
  TaskRunner? Function(CorePondContext context)? taskRunner,
}) async {
  final corePondContext = CorePondContext();

  await corePondContext.register(FloodCoreComponent(
    environmentConfig: environmentConfig,
    initialCoreComponents: initialCoreComponents,
    repositoryImplementations: repositoryImplementations,
    authServiceImplementations: authServiceImplementations,
    actionWrapper: <P, R>(action) => action.log(context: corePondContext),
    authService: (context) => AuthService.static.adapting(memoryIsAdmin: false),
    assetProviderImplementations: assetProviderImplementations,
    taskRunner: taskRunner,
    loggerService: loggerService,
    messagingService: messagingService,
    assetProviders: (context) => [
      TodoAssetProvider(context),
      UserProfilePictureAssetProvider(context),
      UserTokenAssetProvider(context),
    ],
  ));

  await corePondContext.register(UserDeviceTokenCoreComponent(
    onRegisterDeviceToken: (dropContext, userId, deviceToken) async {
      final userEntity = await Query.getByIdOrNull<UserEntity>(userId).get(dropContext);
      if (userEntity == null) {
        return;
      }

      await dropContext.updateEntity(userEntity, (User user) => user..deviceTokenProperty.set(deviceToken));
    },
    onRemoveDeviceToken: (dropContext, userId, deviceToken) async {
      final userEntity = await Query.getByIdOrNull<UserEntity>(userId).get(dropContext);
      if (userEntity == null) {
        return;
      }

      await dropContext.updateEntity(userEntity, (User user) => user..deviceTokenProperty.set(null));
    },
  ));

  await corePondContext.register(TestingUtilityComponent());
  if (corePondContext.testingComponent.useSyncing) {
    await corePondContext.register(SyncCoreComponent());
  }

  await corePondContext.register(UserRepository());
  await corePondContext.register(TodoRepository());
  await corePondContext.register(TagRepository());
  await corePondContext.register(PublicSettingsRepository());
  await corePondContext.register(LocalSettingsRepository());
  return corePondContext;
}

Future<CorePondContext> getTestingCorePondContext() async {
  final corePondContext = await getCorePondContext(
    environmentConfig: EnvironmentConfig.static.testing(),
  );

  await corePondContext
      .locate<AuthCoreComponent>()
      .signup(AuthCredentials.email(email: 'asdf@asdf.com', password: 'mypassword'));

  return corePondContext;
}
