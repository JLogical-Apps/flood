import 'dart:async';
import 'dart:io';

import 'package:example_core/pond.dart';
import 'package:jlogical_utils_cli/jlogical_utils_cli.dart';

Future<dynamic> main(final context) async {
  final corePondContext = await getCorePondContext(
    environmentConfig: EnvironmentConfig.static.fileAssets(projectDirectory: Directory.current.parent / 'example'),
    loggerService: (_) => LoggerService.static.appwrite(context),
    taskRunner: (_) => TaskRunner.static.local,
    repositoryImplementations: (_) => [
      AppwriteCloudRepositoryImplementation(),
    ],
    additionalCoreComponents: (corePondContext) async => [
      AppwriteCoreComponent(
        config: AppwriteConfig.apiKey(
          endpoint: await corePondContext.environmentCoreComponent.get(AppwriteConsts.endpointFunctionEnv),
          projectId: await corePondContext.environmentCoreComponent.get(AppwriteConsts.projectIdFunctionEnv),
          apiKey: await corePondContext.environmentCoreComponent.get(AppwriteConsts.apiKeyFunctionEnv),
        ),
      ),
    ],
  );

  await corePondContext.load();

  await corePondContext.dropCoreComponent.runWithoutSecurity(() => AppwriteBackend.handle(
        corePondContext: corePondContext,
        context: context,
      ));
}
