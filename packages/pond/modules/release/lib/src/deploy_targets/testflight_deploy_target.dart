import 'dart:convert';
import 'dart:io';

import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/deploy_target.dart';
import 'package:release/src/deploy_targets/util/apple_api_key_retrieval_method.dart';
import 'package:release/src/release_context.dart';
import 'package:release/src/release_platform.dart';
import 'package:utils_core/utils_core.dart';

class TestflightDeployTarget with IsDeployTarget {
  @override
  Future onPreBuild(AutomateCommandContext context, ReleaseContext releaseContext, ReleasePlatform platform) async {
    final identifier = await context.getIosIdentifier();

    final apiKeyFile = await createApiKeyFile(
      context,
      apiKeyEncoded: await getApiKeyEncoded(context),
      keyId: await getApiKeyId(context),
      issuerId: await getApiKeyIssuer(context),
    );

    final teamId = await getTeamId(context);
    final gitUrl = await getGitUrl(context);
    final matchPassword = await getMatchPassword(context);

    await context.appProject.run(
      'fastlane match ${releaseContext.isDebug ? 'adhoc' : 'appstore'} '
      '--app_identifier $identifier '
      '--api_key_path ${apiKeyFile.path} '
      '--team_id $teamId '
      '--git_url $gitUrl ',
      environment: {
        'MATCH_PASSWORD': matchPassword,
      },
    );
  }

  @override
  Future onDeploy(AutomateCommandContext context, ReleaseContext releaseContext, ReleasePlatform platform) async {
    final identifier = await context.getIosIdentifier();

    final apiKeyFile = await createApiKeyFile(
      context,
      apiKeyEncoded: await getApiKeyEncoded(context),
      keyId: await getApiKeyId(context),
      issuerId: await getApiKeyIssuer(context),
    );

    final matchPassword = await getMatchPassword(context);
    final appleId = await getAppleId(context);
    final teamId = await getTeamId(context);
    final ipaFile = context.appDirectory / 'build' / 'ios' - 'Runner.ipa';

    final releaseNotesFile = context.appDirectory / 'build' - 'release_notes.txt';
    final releaseNotes = await DataSource.static.file(releaseNotesFile).getOrNull();

    await context.appProject.run(
      'fastlane pilot upload '
      '--app_identifier $identifier '
      '--api_key_path ${apiKeyFile.path} '
      '--ipa ${ipaFile.path} '
      '--apple_id $appleId '
      '--team_id $teamId '
      '--changelog "${releaseNotes ?? ''}" ',
      environment: {
        'MATCH_PASSWORD': matchPassword,
      },
    );
  }

  Future<String> getApiKeyEncoded(AutomateCommandContext context) async {
    return await context.getHiddenStateOrElse('testflight/apiKeyEncoded', () async {
      final apiKeyMethod = context.select(
        prompt: 'Provide an App Store Connect API Key. '
            'This is used for `fastlane match` to be able to sign your app. '
            'There are two ways for you to provide this API Key:\n'
            '1) Create an API Key with Admin priveleges at https://appstoreconnect.apple.com/access/api, '
            'download the .p8 file, and submit the path to the .p8 file.\n'
            '2) If you already have a base-64 encoded API Key from another project, you can simply input that here.\n'
            'How would you like to import your API Key?',
        options: ApiKeyRetrievalMethod.values,
        stringMapper: (method) => method.displayName,
      );

      return await apiKeyMethod.retrieveEncodedApiKey(context);
    });
  }

  Future<File> createApiKeyFile(
    AutomateCommandContext context, {
    required String keyId,
    required String issuerId,
    required String apiKeyEncoded,
  }) async {
    final file = await context.createTempFile('apiKey.json');

    final decodedKey = base64.decode(apiKeyEncoded);
    final decodedKeyString = utf8.decode(decodedKey);

    await DataSource.static.file(file).mapJson().set({
      'key_id': keyId,
      'issuer_id': issuerId,
      'key': decodedKeyString,
      'in_house': false,
    });

    return file;
  }

  Future<String> getApiKeyId(AutomateCommandContext context) async {
    return await context.getHiddenStateOrElse('testflight/apiKeyId', () async {
      final apiKeyId =
          context.input('Provide the App Store Connect Key ID. You will find this as the "KEY ID" of the key.');
      if (apiKeyId.isBlank) {
        throw Exception('App Store Conect Key ID not provided!');
      }

      return apiKeyId;
    });
  }

  Future<String> getApiKeyIssuer(AutomateCommandContext context) async {
    return await context.getHiddenStateOrElse('testflight/apiKeyIssuer', () async {
      final apiKeyIssuer = context.input('Provide the Issuer ID. You will find this as the "Issuer ID"');
      if (apiKeyIssuer.isBlank) {
        throw Exception('App Store Conect Key Issuer not provided!');
      }

      return apiKeyIssuer;
    });
  }

  Future<String> getTeamId(AutomateCommandContext context) async {
    return await context.getHiddenStateOrElse('testflight/teamId', () async {
      final teamId = context.input(
          'Provide the Team ID. You will find this at https://developer.apple.com/account#!/membership towards the bottom of the page.');
      if (teamId.isBlank) {
        throw Exception('Team ID not provided!');
      }

      return teamId;
    });
  }

  Future<String> getGitUrl(AutomateCommandContext context) async {
    return await context.getHiddenStateOrElse('match/gitUrl', () async {
      final gitUrl = context.input(
          'Provide the Git URL for Fastlane to store the iOS certs. Create a new repository if you haven\'t already.');
      if (gitUrl.isBlank) {
        throw Exception('Git URL not provided!');
      }

      return gitUrl;
    });
  }

  Future<String> getMatchPassword(AutomateCommandContext context) async {
    return await context.getHiddenStateOrElse('match/matchPassword', () async {
      final matchPassword = context.input(
          'Provide the Match password to be used to encrypt/decrypt your repository. If you just created a new Git repository, create a password and provide it.');
      if (matchPassword.isBlank) {
        throw Exception('Match password not provided!');
      }

      return matchPassword;
    });
  }

  Future<String> getAppleId(AutomateCommandContext context) async {
    return await context.getHiddenStateOrElse('testflight/appleId', () async {
      final appleId = context.input(
          'Provide the Apple ID of the app. You will find this by going to the App Store page for the app > App Information > General Information > Apple ID.');
      if (appleId.isBlank) {
        throw Exception('Apple ID not provided!');
      }

      return appleId;
    });
  }
}
