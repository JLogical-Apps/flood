import 'dart:async';

import 'package:flood_core/flood_core.dart';

class FloodCoreComponent with IsCorePondComponent {
  final EnvironmentConfig environmentConfig;
  final FutureOr<List<CorePondComponent>> Function(CorePondContext context)? initialCoreComponents;
  final List<RepositoryImplementation> Function(CorePondContext context)? repositoryImplementations;
  final List<AuthServiceImplementation> Function(CorePondContext context)? authServiceImplementations;
  final TaskRunner? Function(CorePondContext context)? taskRunner;
  final LoggerService? Function(CorePondContext context)? loggerService;
  final MessagingService? Function(CorePondContext context)? messagingService;
  final Action<P, R> Function<P, R>(Action<P, R> action)? actionWrapper;

  FloodCoreComponent({
    EnvironmentConfig? environmentConfig,
    this.initialCoreComponents,
    this.repositoryImplementations,
    this.authServiceImplementations,
    this.taskRunner,
    this.loggerService,
    this.messagingService,
    this.actionWrapper,
  }) : environmentConfig = environmentConfig ?? EnvironmentConfig.static.environmentVariables();

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(onRegister: (context, component) async {
          await context.register(TypeCoreComponent());
          await context.register(EnvironmentConfigCoreComponent(environmentConfig: environmentConfig));

          for (final coreComponent in await initialCoreComponents?.call(context) ?? []) {
            await context.register(coreComponent);
          }

          await context.register(TaskCoreComponent(
            taskRunner: taskRunner?.call(context) ?? TaskRunner.static.none,
          ));

          await context.register(LogCoreComponent(
            loggerService: loggerService?.call(context) ?? LoggerService.static.console,
          ));

          await context.register(DropCoreComponent(
            repositoryImplementations: repositoryImplementations?.call(context) ?? [],
            loggedInAccountGetter: () => context.locate<AuthCoreComponent>().accountX.value.getOrNull(),
          ));
          await context.register(AuthCoreComponent(
            authService: AuthService.static.adapting(memoryIsAdmin: true),
            authServiceImplementations: authServiceImplementations?.call(context) ?? [],
          ));
          await context.register(MessagingCoreComponent(
            messagingService: messagingService?.call(context) ?? MessagingService.static.blank,
          ));
          await context.register(ActionCoreComponent(
            actionWrapper: actionWrapper,
          ));
          await context.register(PortDropCoreComponent());
        }),
      ];
}
