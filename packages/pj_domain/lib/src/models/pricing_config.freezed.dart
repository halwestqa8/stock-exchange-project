// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pricing_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PricingConfig _$PricingConfigFromJson(Map<String, dynamic> json) {
  return _PricingConfig.fromJson(json);
}

/// @nodoc
mixin _$PricingConfig {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_price')
  double get basePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_rate')
  double get weightRate => throw _privateConstructorUsedError;

  /// Serializes this PricingConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PricingConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PricingConfigCopyWith<PricingConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PricingConfigCopyWith<$Res> {
  factory $PricingConfigCopyWith(
    PricingConfig value,
    $Res Function(PricingConfig) then,
  ) = _$PricingConfigCopyWithImpl<$Res, PricingConfig>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'base_price') double basePrice,
    @JsonKey(name: 'weight_rate') double weightRate,
  });
}

/// @nodoc
class _$PricingConfigCopyWithImpl<$Res, $Val extends PricingConfig>
    implements $PricingConfigCopyWith<$Res> {
  _$PricingConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PricingConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? basePrice = null,
    Object? weightRate = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            basePrice: null == basePrice
                ? _value.basePrice
                : basePrice // ignore: cast_nullable_to_non_nullable
                      as double,
            weightRate: null == weightRate
                ? _value.weightRate
                : weightRate // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PricingConfigImplCopyWith<$Res>
    implements $PricingConfigCopyWith<$Res> {
  factory _$$PricingConfigImplCopyWith(
    _$PricingConfigImpl value,
    $Res Function(_$PricingConfigImpl) then,
  ) = __$$PricingConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'base_price') double basePrice,
    @JsonKey(name: 'weight_rate') double weightRate,
  });
}

/// @nodoc
class __$$PricingConfigImplCopyWithImpl<$Res>
    extends _$PricingConfigCopyWithImpl<$Res, _$PricingConfigImpl>
    implements _$$PricingConfigImplCopyWith<$Res> {
  __$$PricingConfigImplCopyWithImpl(
    _$PricingConfigImpl _value,
    $Res Function(_$PricingConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PricingConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? basePrice = null,
    Object? weightRate = null,
  }) {
    return _then(
      _$PricingConfigImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        basePrice: null == basePrice
            ? _value.basePrice
            : basePrice // ignore: cast_nullable_to_non_nullable
                  as double,
        weightRate: null == weightRate
            ? _value.weightRate
            : weightRate // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PricingConfigImpl implements _PricingConfig {
  const _$PricingConfigImpl({
    required this.id,
    @JsonKey(name: 'base_price') required this.basePrice,
    @JsonKey(name: 'weight_rate') required this.weightRate,
  });

  factory _$PricingConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$PricingConfigImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'base_price')
  final double basePrice;
  @override
  @JsonKey(name: 'weight_rate')
  final double weightRate;

  @override
  String toString() {
    return 'PricingConfig(id: $id, basePrice: $basePrice, weightRate: $weightRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PricingConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.weightRate, weightRate) ||
                other.weightRate == weightRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, basePrice, weightRate);

  /// Create a copy of PricingConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PricingConfigImplCopyWith<_$PricingConfigImpl> get copyWith =>
      __$$PricingConfigImplCopyWithImpl<_$PricingConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PricingConfigImplToJson(this);
  }
}

abstract class _PricingConfig implements PricingConfig {
  const factory _PricingConfig({
    required final int id,
    @JsonKey(name: 'base_price') required final double basePrice,
    @JsonKey(name: 'weight_rate') required final double weightRate,
  }) = _$PricingConfigImpl;

  factory _PricingConfig.fromJson(Map<String, dynamic> json) =
      _$PricingConfigImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'base_price')
  double get basePrice;
  @override
  @JsonKey(name: 'weight_rate')
  double get weightRate;

  /// Create a copy of PricingConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PricingConfigImplCopyWith<_$PricingConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
