import 'dart:async';
import 'dart:core' as dart;
import 'dart:core';

import 'package:asset_core/asset_core.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_core/src/allowed_file_types_port_field.dart';
import 'package:port_core/src/color_port_field.dart';
import 'package:port_core/src/currency_port_field.dart';
import 'package:port_core/src/display_name_port_field.dart';
import 'package:port_core/src/email_port_field.dart';
import 'package:port_core/src/fallback_port_field.dart';
import 'package:port_core/src/hint_port_field.dart';
import 'package:port_core/src/list_port_field.dart';
import 'package:port_core/src/map_port_field.dart';
import 'package:port_core/src/modifier/port_field_node_modifier.dart';
import 'package:port_core/src/multiline_port_field.dart';
import 'package:port_core/src/name_port_field.dart';
import 'package:port_core/src/phone_port_field.dart';
import 'package:port_core/src/port_field_provider.dart';
import 'package:port_core/src/required_port_field.dart';
import 'package:port_core/src/secret_port_field.dart';
import 'package:port_core/src/validator_port_field.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';
import 'package:uuid/uuid.dart';

typedef SimplePortField<T> = PortField<T, T>;

abstract class PortField<T, S> with IsValidatorWrapper<PortFieldValidatorContext, String> {
  T get value;

  dynamic get error;

  late String fieldPath;

  late Port port;

  S submitRaw(T value);

  FutureOr<S> submit(T value);

  T parseValue(dynamic value);

  PortField<T, S> copyWith({required T value, required dynamic error});

  Type get dataType;

  Type get submitType;

  PortFieldValidatorContext createValidationContext();

  PortFieldProvider? getPortFieldProviderOrNull();

  factory PortField({
    required T value,
    dynamic error,
    Validator<PortFieldValidatorContext, String>? validator,
    S Function(T value)? submitRawMapper,
    FutureOr<S> Function(T value)? submitMapper,
    Type? dataType,
    Type? submitType,
  }) =>
      _PortFieldImpl<T, S>(
        value: value,
        error: error,
        validator: validator ?? Validator.empty(),
        submitRawMapper: submitRawMapper,
        submitMapper: submitMapper,
        dataType: dataType,
        submitType: submitType,
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

  static SimplePortField<dart.bool?> bool({dart.bool? initialValue}) {
    return PortField(value: initialValue);
  }

  static DatePortField<DateTime?, DateTime?> dateTime({
    DateTime? initialValue,
    dart.bool isDate = true,
    dart.bool isTime = true,
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

  static PortField<T, T> search<R, T>({
    required FutureOr<ValueStream<FutureValue<List<R>>>> Function() searchX,
    required T Function(R result) valueMapper,
    required R? Function(T value, List<R> results) resultsMapper,
    required T initialValue,
    T Function(T value)? submitMapper,
  }) {
    return SearchPortField<R, T>(
      portField: PortField(value: initialValue, submitMapper: submitMapper),
      searchX: searchX,
      valueMapper: valueMapper,
      resultsMapper: resultsMapper,
    );
  }

  static ListPortField<T, S> list<T, S>({
    required PortField<T, S> Function(T? value, String fieldPath, Port port) itemPortFieldGenerator,
    List<T>? initialValues,
    List<S> Function(Map<String, T?> value)? submitMapper,
  }) {
    return ListPortField(
      portField: PortField(
        value: (initialValues ?? []).mapToMap((value) => MapEntry(Uuid().v4(), value)),
        submitMapper: submitMapper,
      ),
      itemPortFieldGenerator: itemPortFieldGenerator,
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

  static SimplePortField<CrossFile?> file({CrossFile? initialValue}) {
    return PortField(value: initialValue);
  }

  static AssetPortField asset({
    AssetReference? initialValue,
    required AssetProvider assetProvider,
  }) {
    return AssetPortField(
      value: AssetPortValue.initial(initialValue: initialValue),
      assetProvider: assetProvider,
    );
  }
}

extension PortFieldExtensions<T, S> on PortField<T, S> {
  void registerToPort(String fieldPath, Port port) {
    this.fieldPath = fieldPath;
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

  PortField<T, S> required() => RequiredPortField<T, S>(portField: this);

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

  bool findIsRequired() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.isRequired(this) ?? false;
  }

  StagePortField? findStageFieldOrNull() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.findStagePortFieldOrNull(this);
  }

  AssetPortField? findAssetFieldOrNull() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.findAssetPortFieldOrNull(this);
  }

  DatePortField? findDateFieldOrNull() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.findDatePortFieldOrNull(this);
  }

  ListPortField? findListFieldOrNull() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.findListPortFieldOrNull(this);
  }

  SearchPortField? findSearchFieldOrNull() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.findSearchPortFieldOrNull(this);
  }

  List<T>? findOptionsOrNull() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.getOptionsOrNull(this);
  }

  AllowedFileTypes? findAllowedFileTypes() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.getAllowedFileTypes(this);
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

  bool findIsName() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.isName(this) ?? false;
  }

  bool findIsEmail() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.isEmail(this) ?? false;
  }

  bool findIsPhone() {
    return PortFieldNodeModifier.getModifierOrNull(this)?.isPhone(this) ?? false;
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

  @override
  T parseValue(value) {
    return value;
  }

  @override
  PortFieldProvider? getPortFieldProviderOrNull() {
    return null;
  }
}

class _PortFieldImpl<T, S> with IsPortField<T, S>, IsValidatorWrapper<PortFieldValidatorContext, String> {
  @override
  final T value;

  @override
  final dynamic error;

  @override
  late String fieldPath;

  @override
  late Port port;

  @override
  final Type dataType;

  @override
  final Type submitType;

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
    String? fieldPath,
    Port? port,
    Type? dataType,
    Type? submitType,
  })  : dataType = dataType ?? T,
        submitType = submitType ?? S {
    if (fieldPath != null) {
      this.fieldPath = fieldPath;
    }
    if (port != null) {
      this.port = port;
    }
  }

  @override
  S submitRaw(T value) {
    return submitRawMapper != null ? submitRawMapper!(value) : (value as S);
  }

  @override
  Future<S> submit(T value) async {
    return submitMapper != null ? await submitMapper!(value) : (value as S);
  }

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return _PortFieldImpl(
      value: value,
      error: error,
      validator: validator,
      submitRawMapper: submitRawMapper,
      submitMapper: submitMapper,
      fieldPath: fieldPath,
      port: port,
      dataType: dataType,
      submitType: submitType,
    );
  }

  @override
  PortFieldValidatorContext createValidationContext() {
    return PortFieldValidatorContext(value: value, port: port);
  }

  @override
  PortFieldProvider? getPortFieldProviderOrNull() {
    return null;
  }
}

extension StringPortFieldExtensions<S> on PortField<String, S> {
  PortField<String, S> isNotBlank() =>
      RequiredPortField(portField: this).withValidator(Validator.isNotBlank().asNonNullable().forPortField());

  PortField<String, S> isName([bool isName = true]) => NamePortField(portField: this, isName: isName);

  PortField<String, S> isEmail([bool isEmail = true]) => EmailPortField(portField: this, isEmail: isEmail);

  PortField<String, S> isPhone([bool isPhone = true]) => PhonePortField(portField: this, isPhone: isPhone);

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

extension AssetPortFieldExtensions<S> on PortField<AssetPortValue, S> {
  PortField<AssetPortValue, S> withAllowedFileTypes(AllowedFileTypes allowedFileTypes) =>
      AllowedFileTypesPortField<AssetPortValue, S>(
        portField: this,
        allowedFileTypes: allowedFileTypes,
      );
}

extension FilePortFieldExtensions<T extends CrossFile?, S> on PortField<T, S> {
  PortField<T, S> withAllowedFileTypes(List<String> fileTypes) => AllowedFileTypesPortField<T, S>(
        portField: this,
        allowedFileTypes: AllowedFileTypes.custom(fileTypes),
      );

  PortField<T, S> onlyImages() => AllowedFileTypesPortField<T, S>(
        portField: this,
        allowedFileTypes: AllowedFileTypes.image,
      );

  PortField<T, S> onlyAudio() => AllowedFileTypesPortField<T, S>(
        portField: this,
        allowedFileTypes: AllowedFileTypes.audio,
      );

  PortField<T, S> onlyVideos() => AllowedFileTypesPortField<T, S>(
        portField: this,
        allowedFileTypes: AllowedFileTypes.video,
      );
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
  String get fieldPath => portField.fieldPath;

  @override
  set fieldPath(String fieldPath) => portField.fieldPath = fieldPath;

  @override
  Port get port => portField.port;

  @override
  set port(Port port) => portField.port = port;

  @override
  FutureOr<S> submit(T value) => portField.submit(value);

  @override
  S submitRaw(T value) => portField.submitRaw(value);

  @override
  T parseValue(value) => portField.parseValue(value);

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

  @override
  PortFieldProvider? getPortFieldProviderOrNull() => portField.getPortFieldProviderOrNull();
}

extension PortFieldValidatorExtensions<T> on Validator<T, String> {
  Validator<PortFieldValidatorContext, String> forPortField() {
    return map((context) => context.value);
  }
}
