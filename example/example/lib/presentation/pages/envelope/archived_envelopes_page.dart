import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/presentation/pages/envelope/envelope_page.dart';
import 'package:example/presentation/widget/envelope/envelope_card.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class ArchivedEnvelopesPage extends AppPage<ArchivedEnvelopesPage> {
  late final budgetIdProperty = field<String>(name: 'budgetId').required();

  @override
  PathDefinition get pathDefinition => PathDefinition.string('archived').property(budgetIdProperty);

  @override
  Widget build(BuildContext context) {
    final archivedEnvelopesModel =
        useQuery(EnvelopeEntity.getBudgetEnvelopesQuery(budgetId: budgetIdProperty.value, isArchived: true).paginate());
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
                        context.push(EnvelopePage()..idProperty.set(entity.id!));
                      },
                    ))
                .toList(),
            ifEmptyText: 'You have no archived envelopes!',
          );
        },
      ),
    );
  }

  @override
  ArchivedEnvelopesPage copy() {
    return ArchivedEnvelopesPage();
  }
}
