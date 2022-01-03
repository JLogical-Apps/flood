import 'dart:io';

import 'package:example/pond/domain/budget/budget_repository.dart';
import 'package:example/pond/domain/budget_transaction/budget_transaction_repository.dart';
import 'package:example/pond/domain/envelope/envelope_repository.dart';
import 'package:example/pond/domain/user/user.dart';
import 'package:example/pond/domain/user/user_entity.dart';
import 'package:example/pond/domain/user/user_repository.dart';
import 'package:example/pond/presentation/pond_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class PondUsersPage extends HookWidget {
  static Style style = DeltaStyle(backgroundColor: Color(0xff030818));

  final Directory baseDirectory;

  const PondUsersPage({Key? key, required this.baseDirectory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useOneTimeEffect(() {
      _initPond();
    });
    final usersQuery = useQuery(Query.from<UserEntity>().paginate());
    return StyleProvider(
        style: style,
        child: Builder(
          builder: (context) => ModelBuilder.styledPage(
            model: usersQuery.model,
            builder: (QueryPaginationResultController<UserEntity> userResultController) {
              final results = useValueStream(userResultController.resultsX);
              return StyledPage(
                onRefresh: usersQuery.reload,
                titleText: 'Users',
                body: StyledCategory.medium(
                  headerText: 'Users',
                  actions: [
                    ActionItem(
                      name: 'Create',
                      description: 'Create a new User',
                      leading: Icon(Icons.person_add),
                      color: Colors.green,
                      onPerform: () async {
                        final data = await StyledDialog.smartForm(
                          context: context,
                          titleText: 'Create User',
                          children: [
                            StyledSmartTextField(
                              name: 'name',
                              label: 'Name',
                              validators: [Validation.required()],
                            ),
                            StyledSmartTextField(
                              name: 'email',
                              label: 'Email',
                              validators: [
                                Validation.required(),
                                Validation.isEmail(),
                              ],
                            ),
                          ],
                        ).show(context);
                        if (data == null) {
                          return;
                        }
                        final user = User()
                          ..nameProperty.value = data['name']
                          ..emailProperty.value = data['email'];
                        final userEntity = UserEntity()..value = user;

                        await userEntity.create();
                      },
                    ),
                  ],
                  noChildrenWidget: StyledContentSubtitleText('No users'),
                  children: [
                    ...results.map((userEntity) => UserCard(userId: userEntity.id!)),
                    if (userResultController.canLoadMore)
                      StyledButton.low(
                        text: 'Load More',
                        onTapped: () async {
                          await userResultController.loadMore();
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  void _initPond() {
    AppContext.global = AppContext(
      registration: DatabaseAppRegistration(
        repositories: [
          FileBudgetRepository(baseDirectory: baseDirectory / 'budgets'),
          FileBudgetTransactionRepository(baseDirectory: baseDirectory / 'transactions'),
          FileEnvelopeRepository(baseDirectory: baseDirectory / 'envelopes'),
          FileUserRepository(baseDirectory: baseDirectory / 'users'),
        ],
      ),
    );
  }
}

class UserCard extends HookWidget {
  final String userId;

  const UserCard({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userEntityController = useEntity<UserEntity>(userId);
    return ModelBuilder.styled(
      model: userEntityController.model,
      builder: (UserEntity userEntity) {
        final user = userEntity.value;
        return StyledContent(
          headerText: '${user.nameProperty.value}',
          onTapped: () async {
            context.style().navigateTo(context: context, page: (context) => PondHomePage(userId: userEntity.id!));
          },
          actions: [
            ActionItem(
              name: 'Edit',
              onPerform: () async {
                final edit = await StyledDialog.smartForm(context: context, titleText: 'Edit', children: [
                  StyledSmartTextField(
                    name: 'name',
                    label: 'Name',
                    suggestedValue: user.nameProperty.value,
                  ),
                ]).show(context);
                if (edit == null) {
                  return;
                }

                user.nameProperty.value = edit['name'];
                userEntity.save();
              },
            ),
            ActionItem(name: 'Delete', onPerform: () => userEntity.delete()),
          ],
        );
      },
    );
  }
}
