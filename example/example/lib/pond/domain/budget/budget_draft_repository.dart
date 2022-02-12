import 'package:example/pond/domain/budget/budget_draft.dart';
import 'package:example/pond/domain/budget/budget_draft_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class BudgetDraftRepository extends DefaultLocalRepository<BudgetDraftEntity, BudgetDraft> {
  @override
  BudgetDraftEntity createEntity() {
    return BudgetDraftEntity();
  }

  @override
  BudgetDraft createValueObject() {
    return BudgetDraft();
  }
}
