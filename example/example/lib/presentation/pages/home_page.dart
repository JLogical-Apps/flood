import 'dart:async';

import 'package:example/features/user/user.dart';
import 'package:example/features/user/user_entity.dart';
import 'package:example/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class HomePage extends AppPage {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('home');

  @override
  Widget build(BuildContext context) {
    final loggedInUserIdModel =
        useFutureModel(() => context.appPondContext.find<AuthCoreComponent>().getLoggedInUserId());
    final allUsersModel = useQuery(Query.from<UserEntity>().all<UserEntity>());
    return StyledPage(
      titleText: 'Home',
      body: Center(
        child: Column(
          children: [
            ModelBuilder<String?>(
              model: loggedInUserIdModel,
              builder: (userId) {
                return StyledText.h1('Welcome ${userId!.substring(0, 2)}!');
              },
            ),
            ModelBuilder<List<UserEntity>>(
              model: allUsersModel,
              builder: (userEntities) {
                return Column(
                    children: userEntities.map((entity) => StyledText.h2(entity.value.nameProperty.value)).toList());
              },
            ),
            StyledButton.strong(
              labelText: 'Create +',
              onPressed: () async {
                final newUserEntity = UserEntity()
                  ..value = (User()..nameProperty.set(DateTime.now().second.toString()));
                await context.dropCoreComponent.update(newUserEntity);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  AppPage copy() {
    return HomePage();
  }

  @override
  FutureOr<Uri?> redirectTo(BuildContext context, Uri currentUri) async {
    final loggedInUser = await context.appPondContext.find<AuthCoreComponent>().getLoggedInUserId();
    if (loggedInUser == null) {
      final loginPage = LoginPage()..redirectPathProperty.set(currentUri.toString());
      return loginPage.uri;
    }

    return null;
  }
}
