import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class AddIncomePage extends AppPage<AddIncomePage> {
  const AddIncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StyledPage(
      titleText: 'Add Income',
      body: Container(),
    );
  }

  @override
  AddIncomePage copy() {
    return AddIncomePage();
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('addIncome');
}
