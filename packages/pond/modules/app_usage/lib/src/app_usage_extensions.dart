import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

extension AppUsageBuildContextExtension on BuildContext {
  AppUsageAppComponent get appUsageComponent => find<AppUsageAppComponent>();
}

extension AppUsageAppPondContextExtension on AppPondContext {
  AppUsageAppComponent get appUsageComponent => find<AppUsageAppComponent>();
}
