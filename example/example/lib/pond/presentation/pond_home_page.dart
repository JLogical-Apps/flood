import 'package:example/pond/domain/budget/budget.dart';
import 'package:example/pond/domain/budget/budget_draft_entity.dart';
import 'package:example/pond/domain/budget/budget_entity.dart';
import 'package:example/pond/domain/user/user_entity.dart';
import 'package:example/pond/presentation/budget_created_analytic.dart';
import 'package:example/pond/presentation/pond_budget_page.dart';
import 'package:example/pond/presentation/video_page.dart';
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

    final syncingStatus = useValueStreamOrNull(locateOrNull<SyncingModule>()?.syncingStatusX);

    return Banner(
      message: AppContext.global.environment.name.toUpperCase(),
      location: BannerLocation.topEnd,
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
                            StyledTextPortField(
                              name: 'name',
                              labelText: 'Name',
                            ),
                            StyledTextPortField(
                              name: 'email',
                              labelText: 'Email',
                            ),
                            StyledColorPortField(name: 'color', labelText: 'Color', canBeNone: true),
                            StyledUploadPortField(
                              name: 'profilePicture',
                              labelText: 'Profile Picture',
                              uploadType: UploadType.image,
                            ),
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
                      return ScrollColumn(
                        children: [
                          if (syncingStatus != null)
                            syncingStatus.when(
                              initial: () => StyledLoadingIndicator(),
                              loaded: (_) => StyledIcon(Icons.check_circle),
                              error: (e) => StyledButton.low(
                                icon: Icons.error,
                                onTapped: () async {
                                  final nextAction = await StyledDialog(
                                    titleText: 'Resolve Error',
                                    body: Builder(builder: (context) {
                                      return Column(
                                        children: [
                                          StyledBodyText(
                                            'There was an error syncing and saving your changes online. Please make sure you are connected to the internet. If you are connected and this problem still occurs, consider deleting your local changes, as something may have gone wrong.',
                                          ),
                                          StyledBodyText('Here is the error that occurred: '),
                                          StyledErrorText(e.toString()),
                                          StyledContent.high(
                                            headerText: 'Retry',
                                            bodyText: 'Try to sync/save again.',
                                            onTapped: () => context.style().navigateBack(
                                                  context: context,
                                                  result: 'retry',
                                                ),
                                            trailing: StyledIcon(Icons.chevron_right),
                                          ),
                                          StyledContent.high(
                                            headerText: 'Delete Local Changes',
                                            bodyText:
                                                'Delete your local changes so that the next time you are synced, it will be synced with what is online.',
                                            onTapped: () => context.style().navigateBack(
                                                  context: context,
                                                  result: 'delete',
                                                ),
                                            trailing: StyledIcon(Icons.chevron_right),
                                          ),
                                        ],
                                      );
                                    }),
                                  ).show(context);
                                  if (nextAction == null) {
                                    return;
                                  }

                                  switch (nextAction) {
                                    case 'retry':
                                      await locate<SyncingModule>().reload();
                                      break;
                                    case 'delete':
                                      await locate<SyncingModule>().deleteLocalChanges();
                                      break;
                                  }
                                },
                              ),
                            ),
                          if (profilePictureAsset != null) ...[
                            StyledLoadingAsset(
                              maybeAsset: profilePictureAsset,
                              width: 300,
                              height: 300,
                              onTapped: () {
                                context.style().navigateTo(
                                    context: context,
                                    page: (_) => VideoPage(
                                          assetId: userEntity.value.profilePictureProperty.value!,
                                        ));
                              },
                            ),
                            StyledBodyText('Size: ${profilePictureAsset.getOrNull()?.metadata?.size}'),
                            StyledBodyText(
                                'Last Updated: ${profilePictureAsset.getOrNull()?.metadata?.lastUpdated?.toLocal()}'),
                            StyledBodyText(
                                'Time Created: ${profilePictureAsset.getOrNull()?.metadata?.timeCreated?.toLocal()}'),
                          ],
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
