import 'dart:io';

import 'package:jlogical_utils/jlogical_utils_cli.dart';

Future<void> main(List<String> args) async {
  await automate(
    args: args,
    automationContext: getAutomationContext(),
  );
}

AutomationContext getAutomationContext() {
  return AutomationContext()
    ..registerModule(EnvironmentAutomationModule())
    ..registerModule(AppIconAutomationModule(
        appIconForegroundFile: Directory.current / 'assets' - 'logo_foreground.png',
        backgroundColor: 0x172434,
        banners: [
          AppIconBanner(
            environment: Environment.alpha,
            color: 0xff0000,
          ),
          AppIconBanner(
            environment: Environment.beta,
            color: 0x9A3CCC,
          ),
          AppIconBanner(
            environment: Environment.uat,
            color: 0x0000ff,
          ),
          AppIconBanner(
            environment: Environment.qa,
            color: 0x419C9B,
          ),
        ]))
    ..registerModule(NativeSplashAutomationModule(
      imageFile: Directory.current / 'assets' - 'logo_foreground.png',
      backgroundColor: 0x172434,
    ))
    ..registerModule(FirebaseAutomationModule());
}
