import 'dart:io';

import 'package:example/firebase_options.dart';
import 'package:example/model/model_page.dart';
import 'package:example/pond/domain/budget/budget_repository.dart';
import 'package:example/pond/domain/budget_transaction/budget_transaction_repository.dart';
import 'package:example/pond/domain/envelope/envelope_repository.dart';
import 'package:example/pond/domain/user/user_repository.dart';
import 'package:example/pond/presentation/pond_home_page.dart';
import 'package:example/style/styles_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:path_provider/path_provider.dart';

import 'form/form_page.dart';
import 'pond/domain/user/user.dart';
import 'pond/domain/user/user_entity.dart';
import 'pond/presentation/pond_login_page.dart';
import 'repository/repository_page.dart';

late Directory baseDirectory;

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme.lightTheme(
        primaryColor: Colors.blue,
        accentColor: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('JLogical Utils')),
      body: ListView(
        children: [
          NavigationCard(
            title: Text('Pond'),
            onTap: () async {
              baseDirectory = await getApplicationSupportDirectory();

              _initPond();

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => StyleProvider(
                        style: PondLoginPage.style,
                        child: SplashPage(
                          child: StyledContentHeaderText('JLogical Utils'),
                          beforeLoad: (context) => AppContext.global.reset(),
                          onDone: (context) async {
                            final loggedInId = await locate<AuthService>().getCurrentlyLoggedInUserId();
                            context.style().navigateReplacement(
                                  context: context,
                                  newPage: (_) => loggedInId == null
                                      ? PondLoginPage(baseDirectory: baseDirectory)
                                      : PondHomePage(
                                          userId: loggedInId,
                                          loginBaseDirectory: baseDirectory,
                                        ),
                                );
                          },
                        ),
                      )));
            },
          ),
          NavigationCard(
            title: Text('Forms'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FormPage())),
          ),
          NavigationCard(
            title: Text('Repository'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RepositoryPage())),
          ),
          NavigationCard(
            title: Text('Models'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ModelPage())),
          ),
          NavigationCard(
            title: Text('Style'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => StylesPage())),
          ),
        ],
      ),
    );
  }

  Future<void> _initPond() async {
    AppContext.global = AppContext(environment: await EnvironmentConfig.readFromAssetConfig())
      ..register(FirebaseModule(app: DefaultFirebaseOptions.currentPlatform))
      ..register(BudgetRepository(baseDirectory: baseDirectory / 'budgets'))
      ..register(BudgetTransactionRepository(baseDirectory: baseDirectory / 'transactions'))
      ..register(EnvelopeRepository(baseDirectory: baseDirectory / 'envelopes'))
      ..register(UserRepository(baseDirectory: baseDirectory / 'users'))
      ..register(DefaultAuthModule(
        baseDirectory: baseDirectory / 'auth',
        onAutoSignUp: (userId, email) async {
          final user = User()
            ..emailProperty.value = email
            ..nameProperty.value = 'Test';
          final userEntity = UserEntity()
            ..id = userId
            ..value = user;
          await userEntity.save();
        },
      ))
      ..register(AppVersionModule(
        baseDirectory: baseDirectory,
        currentVersionProvider: AssetDataSource(assetPath: 'assets/config.yaml').mapYaml().map(
              onSave: (obj) => throw UnimplementedError(),
              onLoad: (yaml) => yaml?['version'],
            ),
        minimumVersionProvider: AssetDataSource(assetPath: 'assets/config.yaml').mapYaml().map(
              onSave: (obj) => throw UnimplementedError(),
              onLoad: (yaml) => yaml?['min_version'],
            ),
      ));
  }
}
