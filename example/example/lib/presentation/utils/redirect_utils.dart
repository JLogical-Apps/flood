import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/pages/outdated_page.dart';
import 'package:flood/flood.dart';

extension RedirectAppPageExtensions<R extends Route> on AppPage<R> {
  AppPage<R> checkIfOutdated() {
    return withRedirect((context, route) async {
      final isOutdated = await context.appUsageComponent.isOutdated();
      if (isOutdated && route is! OutdatedRoute) {
        return OutdatedRoute().routeData;
      }

      if (!isOutdated && route is OutdatedRoute) {
        return HomeRoute().routeData;
      }

      return null;
    });
  }

  AppPage<R> onlyIfLoggedIn() {
    return withRedirect((context, route) async {
      final loggedInUserId = context.find<AuthCoreComponent>().loggedInUserId;
      if (loggedInUserId == null) {
        return LoginRoute().routeData;
      }

      return null;
    });
  }

  AppPage<R> onlyIfNotLoggedIn() {
    return withRedirect((context, route) async {
      final loggedInUserId = context.find<AuthCoreComponent>().loggedInUserId;
      if (loggedInUserId != null) {
        return HomeRoute().routeData;
      }

      return null;
    });
  }
}
