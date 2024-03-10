import 'dart:async';

import 'package:example_core/features/todo/todo_repository.dart';
import 'package:example_core/features/user/user.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:example_core/features/user/user_repository.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

Future<CorePondContext> getCorePondContext({
  EnvironmentConfig? environmentConfig,
  FutureOr<List<CorePondComponent>> Function(CorePondContext context)? additionalCoreComponents,
  List<RepositoryImplementation> Function(CorePondContext context)? repositoryImplementations,
  List<AuthServiceImplementation> Function(CorePondContext context)? authServiceImplementations,
  MessagingService? Function(CorePondContext context)? messagingService,
  LoggerService? Function(CorePondContext context)? loggerService,
  TaskRunner? Function(CorePondContext context)? taskRunner,
}) async {
  environmentConfig ??= EnvironmentConfig.static.environmentVariables();

  final corePondContext = CorePondContext();

  await corePondContext.register(TypeCoreComponent());
  await corePondContext.register(EnvironmentConfigCoreComponent(environmentConfig: environmentConfig));

  for (final coreComponent in await additionalCoreComponents?.call(corePondContext) ?? []) {
    await corePondContext.register(coreComponent);
  }

  await corePondContext.register(TaskCoreComponent(
    taskRunner: taskRunner?.call(corePondContext) ?? TaskRunner.static.none,
  ));

  await corePondContext.register(LogCoreComponent(
    loggerService: loggerService?.call(corePondContext) ?? LoggerService.static.console,
  ));

  await corePondContext.register(DropCoreComponent(
    repositoryImplementations: repositoryImplementations?.call(corePondContext) ?? [],
    loggedInAccountGetter: () => corePondContext.locate<AuthCoreComponent>().accountX.value.getOrNull(),
  ));
  await corePondContext.register(AuthCoreComponent(
    authService: AuthService.static.adapting(),
    authServiceImplementations: authServiceImplementations?.call(corePondContext) ?? [],
  ));
  await corePondContext.register(MessagingCoreComponent(
    messagingService: messagingService?.call(corePondContext) ?? MessagingService.static.blank,
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
  await corePondContext.register(ActionCoreComponent(
    actionWrapper: <P, R>(Action<P, R> action) => action.log(context: corePondContext),
  ));
  await corePondContext.register(PortDropCoreComponent());
  await corePondContext.register(UserRepository());
  await corePondContext.register(TodoRepository());
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
