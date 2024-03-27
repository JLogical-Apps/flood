import 'dart:async';

import 'package:app_usage/app_usage.dart';
import 'package:auth/auth.dart';
import 'package:debug/debug.dart';
import 'package:device_files/device_files.dart';
import 'package:drop/drop.dart';
import 'package:environment_banner/environment_banner.dart';
import 'package:firebase/firebase.dart';
import 'package:flood_core/flood_core.dart';
import 'package:focus_grabber/focus_grabber.dart';
import 'package:log/log.dart';
import 'package:pond/pond.dart';
import 'package:port_style_component/port_style_component.dart';
import 'package:reset/reset.dart';
import 'package:share/share.dart';
import 'package:style/style.dart';
import 'package:style_component/style_component.dart';
import 'package:url_bar/url_bar.dart';

class FloodAppComponent with IsAppPondComponent {
  final Style style;
  final FutureOr<Version?> Function()? latestAllowedVersion;

  FloodAppComponent({required this.style, this.latestAllowedVersion});

  @override
  Future onRegister(AppPondContext context) async {
    await context.register(DebugAppComponent());
    await context.register(LogAppComponent());
    await context.register(AppUsageAppComponent(latestAllowedVersion: latestAllowedVersion));
    await context.register(DeviceFilesAppComponent());
    await context.register(FocusGrabberAppComponent());
    await context.register(AuthAppComponent());
    await context.register(DropAppComponent());
    await context.register(ResetAppComponent());
    await context.register(FirebaseCrashlyticsAppComponent());
    await context.register(PortStyleAppComponent());
    await context.register(StyleAppComponent(style: style));
    await context.register(UrlBarAppComponent());
    await context.register(EnvironmentBannerAppComponent());
    await context.register(ShareAppComponent());
  }
}
