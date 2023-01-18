/*
final loggedInUserModel = useFutureModel(() => context.find<AuthComponent>().getLoggedInUserId());
final budgetsQueryController = useQueryOrNull(loggedInUserModel.map((loggedInUserId) => Query.from<BudgetEntity>()
  .where(Budget.ownerField).isEqualTo(loggedInUserId)
  .all<BudgetEntity>()).getOrNull());
return ModelBuilder(
  model: budgetsQueryController.model,
  builder: ...,
);

===

final loggedInUserModel = useFutureModel(() => context.find<AuthComponent>().getLoggedInUserId());
final budgetsModel = useMemoizedModel(() =>
  loggedInUserModel.flatMap((loggedInUserId) => Query.from<BudgetEntity>()
    .where(Budget.ownerField).isEqualTo(loggedInUserId)
    .all<BudgetEntity>()
    .toModel()));
return ModelBuilder(
  model: budgetsModel,
  builder: ...,
);

===

return ModelBuilder(
  model: useFutureModel(() => context.find<AuthComponent>().getLoggedInUserId()),
  builder: (loggedInUserId) {
    return ModelBuilder(
      model: useFutureModel(() => Query.from<BudgetEntity>()
        .where(Budget.ownerField).isEqualTo(loggedInUserId)
        .all<BudgetEntity>()
        .toModel()),
      builder: ...,
    );
  },
);

 */
