import 'package:example/presentation/pages/budget/budget_page.dart';
import 'package:example/presentation/pages/envelope/envelope_page.dart';
import 'package:example/presentation/utils/redirect_utils.dart';
import 'package:example/presentation/widget/envelope/envelope_card.dart';
import 'package:example_core/features/envelope/envelope_entity.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class ArchivedEnvelopesPage with IsAppPageWrapper<ArchivedEnvelopesRoute> {
  @override
  AppPage<ArchivedEnvelopesRoute> get appPage => AppPage<ArchivedEnvelopesRoute>()
      .onlyIfLoggedIn()
      .withParent((context, route) => BudgetRoute()..budgetIdProperty.set(route.budgetIdProperty.value));

  @override
  Widget onBuild(BuildContext context, ArchivedEnvelopesRoute route) {
    final archivedEnvelopesModel = useQuery(
        EnvelopeEntity.getBudgetEnvelopesQuery(budgetId: route.budgetIdProperty.value, isArchived: true).paginate());
    return StyledPage(
      titleText: 'Archived Envelopes',
      body: PaginatedQueryModelBuilder(
        paginatedQueryModel: archivedEnvelopesModel,
        builder: (List<EnvelopeEntity> envelopeEntities, Function()? loadNext) {
          return StyledList.column.scrollable.withScrollbar.centered.withMinChildSize(150)(
            children: envelopeEntities
                .map((entity) => EnvelopeCard(
                      envelope: entity.value,
                      onPressed: () async {
                        context.push(EnvelopeRoute()..idProperty.set(entity.id!));
                      },
                    ))
                .toList(),
            ifEmptyText: 'You have no archived envelopes!',
          );
        },
      ),
    );
  }
}

class ArchivedEnvelopesRoute with IsRoute<ArchivedEnvelopesRoute> {
  late final budgetIdProperty = field<String>(name: 'budgetId').required();

  @override
  PathDefinition get pathDefinition => PathDefinition.string('archived').property(budgetIdProperty);

  @override
  ArchivedEnvelopesRoute copy() {
    return ArchivedEnvelopesRoute();
  }
}
