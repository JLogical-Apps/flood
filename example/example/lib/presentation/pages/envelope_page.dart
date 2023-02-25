import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopePage extends AppPage {
  late final idProperty = field<String>(name: 'id').required();

  @override
  Widget build(BuildContext context) {
    final envelopeModel = useQuery(Query.getById<EnvelopeEntity>(idProperty.value));
    return ModelBuilder.page(
      model: envelopeModel,
      builder: (EnvelopeEntity envelopeEntity) {
        return StyledPage(
          titleText: envelopeEntity.value.nameProperty.value,
          actions: [
            ActionItem(
              titleText: 'Edit',
              descriptionText: 'Edit the Envelope',
              color: Colors.orange,
              iconData: Icons.edit,
              onPerform: (context) async {
                final result = await context.style().showDialog(
                    context,
                    StyledPortDialog(
                      titleText: 'Create New Envelope',
                      port: envelopeEntity.value.asPort(context.corePondContext),
                      children: [
                        StyledTextFieldPortField(
                          fieldName: Envelope.nameField,
                          labelText: 'Name',
                        ),
                      ],
                    ));
                if (result == null) {
                  return;
                }

                await context.dropCoreComponent.update(envelopeEntity..value = result);
              },
            ),
          ],
          body: StyledList.column.scrollable(
            children: [],
          ),
        );
      },
    );
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('envelope').property(idProperty);

  @override
  AppPage copy() {
    return EnvelopePage();
  }

  @override
  AppPage? getParent() {
    return HomePage();
  }
}
