import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/bool_field_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/date_time_field_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/double_field_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/fallback_property_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/fallback_replacement_property_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/indexed_property_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/int_field_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/is_not_blank_property_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/list_field_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/map_field_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/multiline_property_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/reference_field_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/required_property_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/string_field_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/timestamp_field_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/value_object_field_behavior_modifier.dart';
import 'package:ops/src/appwrite/behavior/behavior_modifiers/wrapper_property_behavior_modifier.dart';
import 'package:utils_core/utils_core.dart';

abstract class AppwriteAttributeBehaviorModifier<T extends ValueObjectBehavior>
    with IsTypedModifier<T, ValueObjectBehavior> {
  String getType(T behavior);

  bool isRequired(T behavior) {
    return false;
  }

  bool isIndexed(T behavior) {
    return false;
  }

  bool isArray(T behavior) {
    return false;
  }

  int? getSize(T behavior) {
    return null;
  }

  static final ModifierResolver<AppwriteAttributeBehaviorModifier, ValueObjectBehavior> behaviorModifierResolver =
      Resolver.fromModifiers(
    [
      FallbackPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      FallbackReplacementPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      RequiredPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      IsNotBlankPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      IndexedPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      MultilinePropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      WrapperPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      ValueObjectFieldBehaviorModifier(),
      MapFieldBehaviorModifier(),
      ReferenceFieldBehaviorModifier(),
      StringFieldBehaviorModifier(),
      IntFieldBehaviorModifier(),
      BoolFieldBehaviorModifier(),
      DoubleFieldBehaviorModifier(),
      DateTimeFieldBehaviorModifier(),
      TimestampFieldBehaviorModifier(),
      ListFieldBehaviorModifier(),
    ],
  );

  static AppwriteAttributeBehaviorModifier? getBehaviorModifierOrNull(ValueObjectBehavior behavior) {
    return behaviorModifierResolver.resolveOrNull(behavior);
  }
}

abstract class WrapperAppwriteAttributeBehaviorModifier<T extends ValueObjectBehavior>
    extends AppwriteAttributeBehaviorModifier<T> {
  final AppwriteAttributeBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter;

  WrapperAppwriteAttributeBehaviorModifier({required this.modifierGetter});

  ValueObjectBehavior unwrapBehavior(T behavior);

  @override
  String getType(T behavior) {
    final unwrappedBehavior = unwrapBehavior(behavior);
    return modifierGetter(unwrappedBehavior)?.getType(unwrappedBehavior) ??
        (throw Exception("Couldn't find a modifier for the behavior [$unwrappedBehavior]"));
  }

  @override
  bool isRequired(T behavior) {
    final unwrappedBehavior = unwrapBehavior(behavior);
    return modifierGetter(unwrappedBehavior)?.isRequired(unwrappedBehavior) ?? false;
  }

  @override
  bool isArray(T behavior) {
    final unwrappedBehavior = unwrapBehavior(behavior);
    return modifierGetter(unwrappedBehavior)?.isArray(unwrappedBehavior) ?? false;
  }

  @override
  int? getSize(T behavior) {
    final unwrappedBehavior = unwrapBehavior(behavior);
    return modifierGetter(unwrappedBehavior)?.getSize(unwrappedBehavior) ?? super.getSize(behavior);
  }
}
