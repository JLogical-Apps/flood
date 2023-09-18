import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

extension RedirectAppPageExtensions<R extends Route> on AppPage<R> {
  AppPage<R> onlyIfLoggedIn() {
    return withRedirect((context, route) async {
      final loggedInUserId = context.find<AuthCoreComponent>().loggedInUserId;
      if (loggedInUserId == null) {
        return LoginRoute().uri;
      }

      return null;
    });
  }

  AppPage<R> onlyIfNotLoggedIn() {
    return withRedirect((context, route) async {
      final loggedInUserId = context.find<AuthCoreComponent>().loggedInUserId;
      if (loggedInUserId != null) {
        return HomeRoute().uri;
      }

      return null;
    });
  }
}
