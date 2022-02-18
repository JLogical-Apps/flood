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

import 'form/form_page.dart';
import 'pond/domain/budget/budget_draft_repository.dart';
import 'pond/domain/user/user.dart';
import 'pond/domain/user/user_entity.dart';
import 'pond/presentation/pond_login_page.dart';
import 'repository/repository_page.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme(
        primaryColor: Colors.blue,
        accentColor: Colors.purple,
      ),
      navigatorObservers: [
        PondNavigatorObserver(),
      ],
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
              await _initPond();

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => StyleProvider(
                        style: PondLoginPage.style,
                        child: SplashPage(
                          child: StyledContentHeaderText('JLogical Utils'),
                          beforeLoad: (context) async {
                            if (locate<ConfigModule>().config['reset'] == true) {
                              log('RESETTING POND');
                              await AppContext.global.reset();
                            }
                          },
                          onDone: (context) async {
                            final loggedInId = await locate<AuthService>().getCurrentlyLoggedInUserId();
                            context.style().navigateReplacement(
                                  context: context,
                                  newPage: (_) =>
                                      loggedInId == null ? PondLoginPage() : PondHomePage(userId: loggedInId),
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
    final appContext = await AppContext.createGlobal();
    appContext
      ..register(await FirebaseModule.create(app: DefaultFirebaseOptions.currentPlatform))
      ..register(DefaultAnalyticsModule())
      ..register(BudgetRepository())
      ..register(BudgetDraftRepository())
      ..register(BudgetTransactionRepository())
      ..register(EnvelopeRepository())
      ..register(UserRepository())
      ..register(DefaultAuthModule(
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
        currentVersionProvider: ConfigDataSource().map(
          onSave: (obj) => throw UnimplementedError(),
          onLoad: (yaml) => yaml?['version'],
        ),
        minimumVersionProvider: ConfigDataSource().map(
          onSave: (obj) => throw UnimplementedError(),
          onLoad: (yaml) => yaml?['min_version'],
        ),
      ));
  }
}
