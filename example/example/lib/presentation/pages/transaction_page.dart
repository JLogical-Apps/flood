import 'package:example/presentation/pages/envelope_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransactionPage extends AppPage {
  late final idProperty = field<String>(name: 'id').required();

  @override
  Widget build(BuildContext context) {
    return StyledPage(
      titleText: 'Transaction',
      body: Column(
        children: [
          StyledText.h1(idProperty.value),
        ],
      ),
    );
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('transaction').property(idProperty);

  @override
  AppPage copy() {
    return TransactionPage();
  }

  @override
  AppPage? getParent() {
    return EnvelopePage()..idProperty.set('123');
  }
}
