import 'dart:async';

import 'package:example_core/features/budget/budget_repository.dart';
import 'package:example_core/features/envelope/envelope_repository.dart';
import 'package:example_core/features/settings/settings_repository.dart';
import 'package:example_core/features/transaction/budget_transaction_repository.dart';
import 'package:example_core/features/tray/tray_repository.dart';
import 'package:example_core/features/user/user.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:example_core/features/user/user_repository.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

Future<CorePondContext> getCorePondContext({
  EnvironmentConfig? environmentConfig,
  List<CorePondComponent> Function(CorePondContext context)? additionalCoreComponents,
  List<RepositoryImplementation> repositoryImplementations = const [],
  List<AuthServiceImplementation> authServiceImplementations = const [],
  MessagingService? messagingService,
}) async {
  environmentConfig ??= EnvironmentConfig.static.memory();

  final corePondContext = CorePondContext();

  await corePondContext.register(TypeCoreComponent());
  await corePondContext.register(EnvironmentConfigCoreComponent(environmentConfig: environmentConfig));

  for (final coreComponent in additionalCoreComponents?.call(corePondContext) ?? []) {
    await corePondContext.register(coreComponent);
  }

  await corePondContext.register(LogCoreComponent.console());

  await corePondContext.register(AuthCoreComponent(
    authService: AuthService.static.adapting().withUserDeviceTokenListener(),
    authServiceImplementations: authServiceImplementations,
  ));
  await corePondContext.register(DropCoreComponent(
    repositoryImplementations: repositoryImplementations,
    loggedInAccountX:
        corePondContext.locate<AuthCoreComponent>().accountX.mapWithValue((maybeUserIdX) => maybeUserIdX.getOrNull()),
  ));
  await corePondContext.register(MessagingCoreComponent(
    messagingService: messagingService ?? MessagingService.static.local(),
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
  await corePondContext.register(BudgetRepository());
  await corePondContext.register(EnvelopeRepository());
  await corePondContext.register(TrayRepository());
  await corePondContext.register(SettingsRepository());
  await corePondContext.register(BudgetTransactionRepository());
  return corePondContext;
}

Future<CorePondContext> getTestingCorePondContext() async {
  final corePondContext = await getCorePondContext(
    environmentConfig: EnvironmentConfig.static.testing(),
  );

  await corePondContext.locate<AuthCoreComponent>().signup('asdf@asdf.com', 'mypassword');

  return corePondContext;
}
