import 'dart:convert';
import 'dart:io';

import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/deploy_target.dart';
import 'package:release/src/release_context.dart';
import 'package:release/src/release_platform.dart';
import 'package:utils_core/utils_core.dart';

class GooglePlayDeployTarget with IsDeployTarget {
  final GooglePlayTrack track;
  final bool isDraft;

  GooglePlayDeployTarget({required this.track, this.isDraft = false});

  @override
  Future onDeploy(AutomateCommandContext context, ReleaseContext releaseContext, ReleasePlatform platform) async {
    final identifier = await context.getAndroidIdentifier();

    final jsonKeyFile = await createGooglePlayApiKeyFile(
      context,
      apiKeyEncoded: await getGooglePlayApiKeyContent(context),
    );

    final aabFile = context.appDirectory / 'build' / 'app' / 'outputs' / 'bundle' / 'release' - 'app-release.aab';

    final releaseNotesFile = context.appDirectory / 'build' - 'release_notes.txt';
    final releaseNotes = await DataSource.static.file(releaseNotesFile).getOrNull();

    final metadataDirectory = await getMetadataDirectory(
      context,
      releaseNotes: releaseNotes,
    );

    await context.appProject.run(
      'fastlane supply '
      '--track ${track.name} '
      '--json_key ${jsonKeyFile.path} '
      '--aab ${aabFile.path} '
      '--package_name $identifier '
      '--metadata_path ${metadataDirectory.path} '
      '--release_status ${isDraft ? 'draft' : 'completed'} '
      '--skip_upload_images '
      '--skip_upload_screenshots ',
    );
  }

  Future<File> createGooglePlayApiKeyFile(AutomateCommandContext context, {required String apiKeyEncoded}) async {
    final file = await context.createTempFile('googlePlay.json');

    final decodedKey = base64.decode(apiKeyEncoded);
    final decodedKeyString = utf8.decode(decodedKey);

    await DataSource.static.file(file).set(decodedKeyString);

    return file;
  }

  Future<String> getGooglePlayApiKeyContent(AutomateCommandContext context) async {
    return await context.getHiddenStateOrElse('googlePlay/apiKeyEncoded', () async {
      final apiKeyMethod = context.select(
        prompt: 'Provide a Google Play API Key. '
            'This is used for `fastlane supply` to be able to upload your app to the Play Store. '
            'There are two ways for you to provide this API Key:\n'
            '1) Follow the setup instructions at https://docs.fastlane.tools/actions/upload_to_play_store/#setup '
            'and submit the path to the .json file.\n'
            '2) If you already have a base-64 encoded API Key from another project, you can simply input that here.\n'
            'How would you like to import your API Key?',
        options: ApiKeyRetrievalMethod.values,
        stringMapper: (method) => method.displayName,
      );

      return await apiKeyMethod.retrieveEncodedApiKey(context);
    });
  }

  Future<Directory> getMetadataDirectory(AutomateCommandContext context, {required String? releaseNotes}) async {
    final directory = context.appDirectory / 'build' / 'metadata' / 'android';
    final changelogFile = directory / 'en-US' / 'changelogs' - 'default.txt';
    await DataSource.static.file(changelogFile).set(releaseNotes ?? '');
    return directory;
  }
}

enum GooglePlayTrack {
  production('production'),
  beta('beta'),
  alpha('alpha'),
  internal('internal');

  final String name;

  const GooglePlayTrack(this.name);
}

enum ApiKeyRetrievalMethod {
  jsonFile('json file', _retrieveJsonFileApiKey),
  encoded('encoded api key', _retrieveEncodedApiKey);

  final String displayName;
  final Future<String> Function(AutomateCommandContext context) onRetrieveEncodedApiKey;

  const ApiKeyRetrievalMethod(this.displayName, this.onRetrieveEncodedApiKey);

  Future<String> retrieveEncodedApiKey(AutomateCommandContext context) {
    return onRetrieveEncodedApiKey(context);
  }
}

Future<String> _retrieveJsonFileApiKey(AutomateCommandContext context) async {
  final jsonFileLocation = context.input('What is the path to your json file?');
  if (jsonFileLocation.isBlank) {
    throw Exception('.json file not provided!');
  }

  final jsonFile = File(jsonFileLocation);
  final contents = await DataSource.static.rawFile(jsonFile).get();
  return base64Encode(contents);
}

Future<String> _retrieveEncodedApiKey(AutomateCommandContext context) async {
  final encodedJson = context.input('What is your base64-encoded json file?');
  if (encodedJson.isBlank) {
    throw Exception('Base64-encoded json not provided!');
  }

  return encodedJson;
}
