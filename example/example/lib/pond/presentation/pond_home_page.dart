import 'package:example/pond/domain/budget/budget.dart';
import 'package:example/pond/domain/budget/budget_draft_entity.dart';
import 'package:example/pond/domain/budget/budget_entity.dart';
import 'package:example/pond/domain/user/user_entity.dart';
import 'package:example/pond/presentation/budget_created_analytic.dart';
import 'package:example/pond/presentation/pond_budget_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/budget/budget_draft.dart';
import 'pond_login_page.dart';

class PondHomePage extends HookWidget {
  final String userId;

  const PondHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userEntityController = useEntity<UserEntity>(userId);
    final userBudgetsController = useQuery(
      Query.from<BudgetEntity>()
          .where(Budget.ownerField, isEqualTo: userId)
          .orderByDescending(ValueObject.timeCreatedField)
          .paginate(),
    );

    return Banner(
      message: AppContext.global.environment.name.toUpperCase(),
      location: BannerLocation.topEnd,
      textDirection: TextDirection.ltr,
      layoutDirection: TextDirection.ltr,
      color: Colors.red,
      child: StyleProvider(
        style: PondLoginPage.style,
        child: Builder(builder: (context) {
          return ModelBuilder.styledPage(
            model: userEntityController.model,
            builder: (UserEntity userEntity) {
              return StyledPage(
                onRefresh: () => Future.wait([userEntityController.reload(), userBudgetsController.reload()]),
                titleText: 'Home: ${userEntity.value.nameProperty.value}',
                actions: [
                  ActionItem(
                      name: 'Edit Profile',
                      onPerform: () async {
                        final port = userEntity.value.toPort();
                        final result = await StyledDialog.port(
                          context: context,
                          port: port,
                          children: [
                            StyledTextPortField(name: 'name'),
                            StyledTextPortField(name: 'email'),
                            StyledColorPortField(name: 'color', canBeNone: true),
                            StyledUploadPortField(name: 'profilePicture'),
                          ],
                        ).show(context);

                        if (result == null) {
                          return;
                        }

                        userEntity.value = result;
                        await userEntity.save();
                      }),
                  ActionItem(
                    name: 'Upload Video',
                    color: Colors.blue,
                    icon: Icons.video_call,
                    onPerform: () async {
                      final asset = await VideoAssetPicker.pickVideoFromGallery();
                      if (asset == null) {
                        return;
                      }

                      final user = userEntity.value;
                      await user.profilePictureProperty.uploadNewAssetAndSet(asset);

                      userEntity.value = user;
                      await userEntity.save();
                    },
                  ),
                  ActionItem(
                      name: 'Share Logs',
                      onPerform: () async {
                        final logFile = await locate<DefaultLoggingModule>().getLogFile();
                        await Share.shareFiles([logFile.path], text: 'Logs');
                      }),
                  ActionItem(
                    name: 'Log Out',
                    icon: Icons.logout,
                    onPerform: () async {
                      await locate<AuthService>().logout();
                      context.style().navigateReplacement(context: context, newPage: (_) => PondLoginPage());
                    },
                  ),
                ],
                body: ModelBuilder.styled(
                  model: userBudgetsController.model,
                  builder: (QueryPaginationResultController<BudgetEntity> budgetsController) {
                    return HookBuilder(builder: (context) {
                      final results = useValueStream(budgetsController.resultsX);
                      final profilePictureAsset = useAssetOrNull(userEntity.value.profilePictureProperty.value);
                      return Column(
                        children: [
                          if (userEntity.value.profilePictureProperty.value != null)
                            StyledLoadingAsset(
                              asset: profilePictureAsset,
                              width: 300,
                              height: 300,
                            ),
                          StyledCategory.medium(
                            headerText: 'Budgets',
                            actions: [
                              ActionItem(
                                name: 'Create',
                                description: 'Create a budget for this user.',
                                color: Colors.green,
                                icon: Icons.monetization_on,
                                onPerform: () async {
                                  final draftEntity = await Singleton.getOrCreate<BudgetDraftEntity, BudgetDraft>();
                                  final budgetDraft = draftEntity.value.sourcePrototype;

                                  final data = await StyledDialog.port(
                                    context: context,
                                    port: Port(
                                      fields: [
                                        StringPortField(
                                          name: 'name',
                                          initialValue: budgetDraft.nameProperty.getUnvalidated(),
                                        ).required(),
                                      ],
                                    ),
                                    // TODO onFormChange: (controller) async {
                                    //   final budget = Budget()..nameProperty.setUnvalidated(controller.getData('name'));
                                    //   final budgetDraft = BudgetDraft()..sourcePrototype = budget;
                                    //   draftEntity..value = budgetDraft;
                                    //   await draftEntity.createOrSave();
                                    // },
                                    children: [
                                      StyledTextPortField(
                                        name: 'name',
                                        labelText: 'Name',
                                      ),
                                    ],
                                  ).show(context);

                                  if (data == null) {
                                    return;
                                  }

                                  await draftEntity.delete();

                                  final budget = Budget()
                                    ..nameProperty.value = data['name']
                                    ..ownerProperty.value = userId;

                                  final budgetEntity = BudgetEntity()..value = budget;

                                  await budgetEntity.create();
                                  await BudgetCreatedAnalytic().log();
                                },
                              ),
                            ],
                            noChildrenWidget: StyledContentSubtitleText('No budgets'),
                            children: [
                              ...results.map((budget) => BudgetCard(
                                    budgetId: budget.id!,
                                    key: ValueKey(budget.id),
                                  )),
                              if (budgetsController.canLoadMore)
                                StyledButton.low(
                                  text: 'Load More',
                                  onTapped: () async {
                                    await budgetsController.loadMore();
                                  },
                                ),
                            ],
                          ),
                        ],
                      );
                    });
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class BudgetCard extends HookWidget {
  final String budgetId;

  const BudgetCard({Key? key, required this.budgetId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final budgetEntityController = useEntity<BudgetEntity>(budgetId);

    return ModelBuilder.styled(
      model: budgetEntityController.model,
      builder: (BudgetEntity budgetEntity) {
        final budget = budgetEntity.value;
        return StyledContent(
          headerText: budget.nameProperty.value,
          onTapped: () {
            context.style().navigateTo(context: context, page: (context) => PondBudgetPage(budgetId: budgetEntity.id!));
          },
          actions: [
            ActionItem.high(
              name: 'Share',
              description: 'Share this budget.',
              icon: Icons.ios_share,
              color: Colors.blue,
              onPerform: () {},
            ),
            ActionItem(
              name: 'Delete',
              description: 'Delete this budget.',
              color: Colors.red,
              icon: Icons.delete,
              onPerform: () async {
                final dialog = StyledDialog.yesNo(
                  context: context,
                  titleText: 'Confirm Delete',
                  children: [
                    StyledBodyText('Are you sure you want to delete this budget?'),
                  ],
                );
                if (await dialog.show(context) == true) {
                  await budgetEntity.delete();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
