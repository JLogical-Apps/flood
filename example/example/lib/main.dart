import 'dart:async';

import 'package:example/firebase_options.dart';
import 'package:example/model/model_page.dart';
import 'package:example/pond/domain/assets/adapting_asset_provider.dart';
import 'package:example/pond/domain/budget/budget_repository.dart';
import 'package:example/pond/domain/budget_transaction/budget_transaction_entity.dart';
import 'package:example/pond/domain/budget_transaction/budget_transaction_repository.dart';
import 'package:example/pond/domain/envelope/envelope_repository.dart';
import 'package:example/pond/domain/user/user_repository.dart';
import 'package:example/pond/presentation/pond_home_page.dart';
import 'package:example/style/styles_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'debug_view/debug_page.dart';
import 'form/form_page.dart';
import 'pond/domain/budget/budget_draft_repository.dart';
import 'pond/domain/budget/budget_entity.dart';
import 'pond/domain/user/user.dart';
import 'pond/domain/user/user_entity.dart';
import 'pond/presentation/pond_login_page.dart';

Future<void> main() async {
  runZonedGuarded(() {
    runApp(MyApp());
  }, (err, stack) {
    print(err);
    print(stack);

    logError(err, stack: stack);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
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
            title: Text('Debugger'),
            onTap: () async {
              await _initDebugPond();

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => StyleProvider(
                        style: DebugPage.style,
                        child: SplashPage(
                          child: StyledContentHeaderText('Debugger'),
                          beforeLoad: (context) async {
                            if (locate<ConfigModule>().config['reset'] == true) {
                              log('RESETTING POND');
                              await AppContext.global.reset();
                            }
                          },
                          onDone: (context) async {
                            context.style().navigateReplacement(context: context, newPage: (_) => DebugPage());
                          },
                        ),
                      )));
            },
          ),
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
                            if (loggedInId == null) {
                              context.style().navigateReplacement(
                                    context: context,
                                    newPage: (_) => PondLoginPage(),
                                  );
                            } else {
                              context.style().navigateReplacement(
                                    context: context,
                                    newPage: (_) => PondHomePage(userId: loggedInId),
                                  );
                            }
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
    final appContext = await AppContext.create();
    appContext
      ..register(await FirebaseModule.create(app: DefaultFirebaseOptions.currentPlatform))
      ..register(DebugModule())
      ..register(AssetModule(assetProvider: AdaptingAssetProvider().assetProvider))
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
      ..register(PushNotificationsModule(onDeviceTokenGenerated: (token) {
        print('token generated: $token');
      }))
      ..register(SyncingModule(isDisabled: kIsWeb || AppContext.global.environment.index < Environment.qa.index)
        ..registerQueryDownload(() async =>
            (await _getLoggedInUserId()).mapIfNonNull((loggedInUserId) => Query.getById<UserEntity>(loggedInUserId)))
        ..registerQueryDownload(() async => (await _getLoggedInUserId())
            .mapIfNonNull((loggedInUserId) => UserEntity.getBudgetsQueryFromUser(loggedInUserId).all()))
        ..registerQueryDownloads(() async {
          final budgetEntities = await _getCurrentBudgetEntities();
          return budgetEntities.map((entity) => BudgetEntity.getEnvelopesQueryFromBudget(entity.id!).all()).toList();
        })
        ..registerQueryDownloads(() async {
          final budgetEntities = await _getCurrentBudgetEntities();
          return budgetEntities
              .map((entity) => BudgetTransactionEntity.getBudgetTransactionsQueryFromBudget(entity.id!).all())
              .toList();
        })
        ..registerDownload(AssetSyncDownloadAction(
          downloadAssetIdsGetter: () async {
            final loggedInUserId = await _getLoggedInUserId();
            if (loggedInUserId == null) {
              return [];
            }

            final loggedInUserEntity =
                await locate<SyncingModule>().executeQueryOnSource(Query.getById<UserEntity>(loggedInUserId));
            final profilePictureId = loggedInUserEntity?.value.profilePictureProperty.value;

            final budgetEntities = await _getCurrentBudgetEntities();
            final budgetImageIds = budgetEntities.expand((entity) => entity.value.imagesProperty.value!).toList();

            return [
              if (profilePictureId != null) profilePictureId,
              ...budgetImageIds,
            ];
          },
          priority: SyncDownloadPriority.low,
        )));
  }

  Future<String?> _getLoggedInUserId() {
    return locate<AuthService>().getCurrentlyLoggedInUserId();
  }

  Future<List<BudgetEntity>> _getCurrentBudgetEntities() async {
    final loggedInUserId = await _getLoggedInUserId();
    if (loggedInUserId == null) {
      return [];
    }

    return await locate<SyncingModule>().executeQueryOnSource<BudgetEntity, List<BudgetEntity>>(
        UserEntity.getBudgetsQueryFromUser(loggedInUserId).all());
  }

  Future<void> _initDebugPond() async {
    final appContext = await AppContext.create();
    appContext..register(CommandModule());
  }
}
