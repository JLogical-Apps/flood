import 'package:ops/src/appwrite/trigger/appwrite_cron_trigger_modifier.dart';
import 'package:task_core/task_core.dart';
import 'package:utils_core/utils_core.dart';

abstract class AppwriteTriggerModifier<T extends Trigger> with IsTypedModifier<T, Trigger> {
  Future onRun(T trigger);

  String? getSchedule(T trigger);

  static final appwriteTriggerModifierResolver = ModifierResolver<AppwriteTriggerModifier, Trigger>(modifiers: [
    AppwriteCronTriggerModifier(),
  ]);

  static AppwriteTriggerModifier getModifier(Trigger trigger) {
    return appwriteTriggerModifierResolver.resolve(trigger);
  }
}
