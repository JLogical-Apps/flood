import 'dart:async';
import 'dart:core' as dart;
import 'dart:core';

import 'package:port_core/src/color_port_field.dart';
import 'package:port_core/src/currency_port_field.dart';
import 'package:port_core/src/date_port_field.dart';
import 'package:port_core/src/display_name_port_field.dart';
import 'package:port_core/src/email_port_field.dart';
import 'package:port_core/src/fallback_port_field.dart';
import 'package:port_core/src/hint_port_field.dart';
import 'package:port_core/src/map_port_field.dart';
import 'package:port_core/src/modifier/port_field_node_modifier.dart';
import 'package:port_core/src/multiline_port_field.dart';
import 'package:port_core/src/options_port_field.dart';
import 'package:port_core/src/port.dart';
import 'package:port_core/src/port_field_validator_context.dart';
import 'package:port_core/src/secret_port_field.dart';
import 'package:port_core/src/stage_port_field.dart';
import 'package:port_core/src/validator_port_field.dart';
import 'package:utils_core/utils_core.dart';

typedef SimplePortField<T> = PortField<T, T>;

abstract class PortField<T, S> with IsValidatorWrapper<PortFieldValidatorContext, String> {
  T get value;

  dynamic get error;

  late Port port;

  S submitRaw(T value);

  FutureOr<S> submit(T value);

  PortField<T, S> copyWith({required T value, required dynamic error});

  Type get dataType;

  Type get submitType;

  PortFieldValidatorContext createValidationContext();

  factory PortField({
    required T value,
    dynamic error,
    Validator<PortFieldValidatorContext, String>? validator,
    S Function(T value)? submitRawMapper,
    FutureOr<S> Function(T value)? submitMapper,
  }) =>
      _PortFieldImpl<T, S>(
        value: value,
        error: error,
        validator: validator ?? Validator.empty(),
        submitRawMapper: submitRawMapper,
        submitMapper: submitMapper,
      );

  static SimplePortField<String> string({String? initialValue}) {
    return PortField(value: initialValue ?? '');
  }

  static SimplePortField<dart.int?> int({dart.int? initialValue}) {
    return PortField(value: initialValue);
  }

  static SimplePortField<dart.double?> double({dart.double? initialValue}) {
    return PortField(value: initialValue);
  }

  static DatePortField<DateTime?, DateTime?> dateTime({
    DateTime? initialValue,
    bool isDate = true,
    bool isTime = true,
  }) {
    return DatePortField(
      portField: PortField(value: initialValue),
      isDate: isDate,
      isTime: isTime,
    );
  }

  static PortField<T, S> option<T, S>({
    required List<T> options,
    required T initialValue,
    S Function(T value)? submitMapper,
  }) {
    return OptionsPortField(
      portField: PortField(value: initialValue, submitMapper: submitMapper),
      options: options,
    );
  }

  static StagePortField<E, T> stage<E, T>({
    required E initialValue,
    required List<E> options,
    required Port<T>? Function(E option) portMapper,
    String? Function(E option)? displayNameMapper,
    T Function(Port<T>? portValue, E option)? submitRawMapper,
  }) {
    return StagePortField<E, T>(
      initialValue: initialValue,
      options: options,
      portMapper: portMapper,
      displayNameMapper: displayNameMapper,
      submitRawMapper: submitRawMapper,
    );
  }

  static PortField<Port<T>, T> embedded<T>({required Port<T> port}) {
    return PortField(
      value: port,
      submitMapper: (port) async => (await port.submit()).data,
    ).withValidator(Validator((context) async {
      final port = context.value;
      final result = await port.submit();
      if (!result.isValid) {
        return 'Embedded port [$port] is not valid!';
      }
      return null;
    }));
  }
}

extension PortFieldExtensions<T, S> on PortField<T, S> {
  void registerToPort(Port port) {
    this.port = port;
  }

  T? getOrNull() => error == null ? value : null;

  PortField<T, S> copyWithValue(T value) => copyWith(value: value, error: error);

  PortField<T, S> copyWithError(dynamic error) => copyWith(value: value, error: error);

  PortField<T, S> withValidator(Validator<PortFieldValidatorContext, String> validator) => ValidatorPortField(
        portField: this,
        additionalValidator: validator,
      );

  PortField<T2, S2> map<T2, S2>({
    required T Function(T2 value) newToSourceMapper,
    required T2 Function(T value) sourceToNewMapper,
    required S2 Function(S value) submitMapper,
  }) =>
      MapPortField<T, S, T2, S2>(
        portField: this,
        newToSourceMapper: newToSourceMapper,
        sourceToNewMapper: sourceToNewMapper,
        submitMapper: submitMapper,
      );

  PortField<T2, S2> cast<T2, S2>() => map<T2, S2>(
        sourceToNewMapper: (data) => data as T2,
        newToSourceMapper: (data) => data as T,
        submitMapper: (submit) => submit as S2,
      );

  PortField<T, S> isNotNull() => withValidator(Validator.isNotNull<T>().forPortField());

  PortField<T, S> withDisplayName(String displayName) =>
      DisplayNamePortField<T, S>(portField: this, displayNameGetter: (port) => displayName);

  PortField<T, S> withDynamicDisplayName(String? Function(Port port) displayNameGetter) =>
      DisplayNamePortField<T, S>(portField: this, displayNameGetter: displayNameGetter);

  PortField<T, S> withFallback(T fallback) =>
      FallbackPortField<T, S>(portField: this, fallbackGetter: (port) => fallback);

  PortField<T, S> withDynamicFallback(T Function(Port port) fallbackGetter) =>
      FallbackPortField<T, S>(portField: this, fallbackGetter: fallbackGetter);

  PortField<T, S> withHint(T? hint) => HintPortField<T, S>(portField: this, hintGetter: (port) => hint);

  PortField<T, S> withDynamicHint(T? Function(Port port) hintGetter) =>
      HintPortField<T, S>(portField: this, hintGetter: hintGetter);

  StagePortField? findStageFieldOrNull() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.findStagePortFieldOrNull(this);
  }

  DatePortField? findDateFieldOrNull() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.findDatePortFieldOrNull(this);
  }

  List<T>? findOptionsOrNull() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.getOptionsOrNull(this);
  }

  String? findDisplayNameOrNull() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.getDisplayNameOrNull(this);
  }

  T? findHintOrNull() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.getHintOrNull(this);
  }

  bool findIsMultiline() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.isMultiline(this) ?? false;
  }

  bool findIsEmail() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.isEmail(this) ?? false;
  }

  bool findIsSecret() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.isSecret(this) ?? false;
  }

  bool findIsCurrency() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.isCurrency(this) ?? false;
  }

  bool findIsColor() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.isColor(this) ?? false;
  }
}

mixin IsPortField<T, S> implements PortField<T, S> {
  @override
  Type get dataType => T;

  @override
  Type get submitType => S;
}

class _PortFieldImpl<T, S> with IsPortField<T, S>, IsValidatorWrapper<PortFieldValidatorContext, String> {
  @override
  final T value;

  @override
  final dynamic error;

  @override
  late Port port;

  @override
  final Validator<PortFieldValidatorContext, String> validator;

  final S Function(T value)? submitRawMapper;

  final FutureOr<S> Function(T value)? submitMapper;

  _PortFieldImpl({
    required this.value,
    this.error,
    required this.validator,
    required this.submitRawMapper,
    required this.submitMapper,
    Port? port,
  }) {
    if (port != null) {
      this.port = port;
    }
  }

  @override
  S submitRaw(T value) {
    return submitRawMapper?.mapIfNonNull((mapper) => mapper(value)) ?? (value as S);
  }

  @override
  Future<S> submit(T value) async {
    return submitMapper?.mapIfNonNull((mapper) async => await mapper(value)) ?? (value as S);
  }

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return _PortFieldImpl(
      value: value,
      error: error,
      validator: validator,
      submitRawMapper: submitRawMapper,
      submitMapper: submitMapper,
      port: port,
    );
  }

  @override
  PortFieldValidatorContext createValidationContext() {
    return PortFieldValidatorContext(value: value, port: port);
  }
}

extension StringPortFieldExtensions<S> on PortField<String, S> {
  PortField<String, S> isNotBlank() => withValidator(Validator.isNotBlank().asNonNullable().forPortField());

  PortField<String, S> isEmail([bool isEmail = true]) => EmailPortField(portField: this, isEmail: isEmail);

  PortField<String, S> isSecret([bool isPassword = true]) => SecretPortField(portField: this, isSecret: isPassword);

  PortField<String, S> isPassword([bool isPassword = true]) => SecretPortField(portField: this, isSecret: isPassword);

  PortField<String, S> isConfirmPassword({required String passwordField}) =>
      SecretPortField(portField: this).withValidator(Validator((context) {
        if (context.port[passwordField] != context.value) {
          return 'Does not match password!';
        }

        return null;
      }));

  PortField<String, S> multiline([bool isMultiline = true]) =>
      MultilinePortField(portField: this, isMultiline: isMultiline);
}

extension IntPortFieldExtensions<T extends int?, S> on PortField<T, S> {
  PortField<T, S> currency([bool isCurrency = true]) =>
      CurrencyPortField<T, S>(portField: this, isCurrency: isCurrency);

  PortField<T, S> color([bool isColor = true]) => ColorPortField<T, S>(portField: this, isColor: isColor);
}

extension DatePortFieldExtensions<T extends DateTime?, S> on PortField<T, S> {
  PortField<T, S> dateTime([bool isDate = true, bool isTime = true]) =>
      DatePortField<T, S>(portField: this, isDate: isDate, isTime: isTime);
}

abstract class PortFieldWrapper<T, S> implements PortField<T, S> {
  PortField<T, S> get portField;
}

mixin IsPortFieldWrapper<T, S> implements PortFieldWrapper<T, S> {
  @override
  T get value => portField.value;

  @override
  dynamic get error => portField.error;

  @override
  Port get port => portField.port;

  @override
  set port(Port port) => portField.port = port;

  @override
  FutureOr<S> submit(T value) => portField.submit(value);

  @override
  S submitRaw(T value) => portField.submitRaw(value);

  @override
  Validator<PortFieldValidatorContext, String> get validator => portField.validator;

  @override
  Future<String?> onValidate(data) {
    return validator.validate(data);
  }

  @override
  Type get dataType => portField.dataType;

  @override
  Type get submitType => portField.submitType;

  @override
  PortFieldValidatorContext createValidationContext() {
    return PortFieldValidatorContext(value: value, port: port);
  }
}

extension PortFieldValidatorExtensions<T> on Validator<T, String> {
  Validator<PortFieldValidatorContext, String> forPortField() {
    return map((context) => context.value);
  }
}
