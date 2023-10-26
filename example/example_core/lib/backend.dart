import 'dart:async';
import 'dart:io';

import 'package:example_core/pond.dart';
import 'package:jlogical_utils_cli/jlogical_utils_cli.dart';

Future<dynamic> main(final context) async {
  final corePondContext = await getCorePondContext(
    environmentConfig: EnvironmentConfig.static.fileAssets(projectDirectory: Directory.current.parent / 'example'),
    loggerService: (_) => LoggerService.static.appwrite(context),
  );
  return await AppwriteServe.serve(
    corePondContext: corePondContext,
    context: context,
  );
}
