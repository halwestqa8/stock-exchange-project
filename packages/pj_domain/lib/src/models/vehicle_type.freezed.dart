// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VehicleType _$VehicleTypeFromJson(Map<String, dynamic> json) {
  return _VehicleType.fromJson(json);
}

/// @nodoc
mixin _$VehicleType {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_en')
  String get nameEn => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_ku')
  String get nameKu => throw _privateConstructorUsedError;
  double get multiplier => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_days_offset')
  int get deliveryDaysOffset => throw _privateConstructorUsedError;

  /// Serializes this VehicleType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleTypeCopyWith<VehicleType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleTypeCopyWith<$Res> {
  factory $VehicleTypeCopyWith(
    VehicleType value,
    $Res Function(VehicleType) then,
  ) = _$VehicleTypeCopyWithImpl<$Res, VehicleType>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'name_en') String nameEn,
    @JsonKey(name: 'name_ku') String nameKu,
    double multiplier,
    @JsonKey(name: 'delivery_days_offset') int deliveryDaysOffset,
  });
}

/// @nodoc
class _$VehicleTypeCopyWithImpl<$Res, $Val extends VehicleType>
    implements $VehicleTypeCopyWith<$Res> {
  _$VehicleTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameEn = null,
    Object? nameKu = null,
    Object? multiplier = null,
    Object? deliveryDaysOffset = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nameEn: null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String,
            nameKu: null == nameKu
                ? _value.nameKu
                : nameKu // ignore: cast_nullable_to_non_nullable
                      as String,
            multiplier: null == multiplier
                ? _value.multiplier
                : multiplier // ignore: cast_nullable_to_non_nullable
                      as double,
            deliveryDaysOffset: null == deliveryDaysOffset
                ? _value.deliveryDaysOffset
                : deliveryDaysOffset // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VehicleTypeImplCopyWith<$Res>
    implements $VehicleTypeCopyWith<$Res> {
  factory _$$VehicleTypeImplCopyWith(
    _$VehicleTypeImpl value,
    $Res Function(_$VehicleTypeImpl) then,
  ) = __$$VehicleTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'name_en') String nameEn,
    @JsonKey(name: 'name_ku') String nameKu,
    double multiplier,
    @JsonKey(name: 'delivery_days_offset') int deliveryDaysOffset,
  });
}

/// @nodoc
class __$$VehicleTypeImplCopyWithImpl<$Res>
    extends _$VehicleTypeCopyWithImpl<$Res, _$VehicleTypeImpl>
    implements _$$VehicleTypeImplCopyWith<$Res> {
  __$$VehicleTypeImplCopyWithImpl(
    _$VehicleTypeImpl _value,
    $Res Function(_$VehicleTypeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VehicleType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameEn = null,
    Object? nameKu = null,
    Object? multiplier = null,
    Object? deliveryDaysOffset = null,
  }) {
    return _then(
      _$VehicleTypeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nameEn: null == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String,
        nameKu: null == nameKu
            ? _value.nameKu
            : nameKu // ignore: cast_nullable_to_non_nullable
                  as String,
        multiplier: null == multiplier
            ? _value.multiplier
            : multiplier // ignore: cast_nullable_to_non_nullable
                  as double,
        deliveryDaysOffset: null == deliveryDaysOffset
            ? _value.deliveryDaysOffset
            : deliveryDaysOffset // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleTypeImpl implements _VehicleType {
  const _$VehicleTypeImpl({
    required this.id,
    @JsonKey(name: 'name_en') required this.nameEn,
    @JsonKey(name: 'name_ku') required this.nameKu,
    this.multiplier = 1.0,
    @JsonKey(name: 'delivery_days_offset') this.deliveryDaysOffset = 0,
  });

  factory _$VehicleTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleTypeImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'name_en')
  final String nameEn;
  @override
  @JsonKey(name: 'name_ku')
  final String nameKu;
  @override
  @JsonKey()
  final double multiplier;
  @override
  @JsonKey(name: 'delivery_days_offset')
  final int deliveryDaysOffset;

  @override
  String toString() {
    return 'VehicleType(id: $id, nameEn: $nameEn, nameKu: $nameKu, multiplier: $multiplier, deliveryDaysOffset: $deliveryDaysOffset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleTypeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.nameKu, nameKu) || other.nameKu == nameKu) &&
            (identical(other.multiplier, multiplier) ||
                other.multiplier == multiplier) &&
            (identical(other.deliveryDaysOffset, deliveryDaysOffset) ||
                other.deliveryDaysOffset == deliveryDaysOffset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nameEn,
    nameKu,
    multiplier,
    deliveryDaysOffset,
  );

  /// Create a copy of VehicleType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleTypeImplCopyWith<_$VehicleTypeImpl> get copyWith =>
      __$$VehicleTypeImplCopyWithImpl<_$VehicleTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleTypeImplToJson(this);
  }
}

abstract class _VehicleType implements VehicleType {
  const factory _VehicleType({
    required final int id,
    @JsonKey(name: 'name_en') required final String nameEn,
    @JsonKey(name: 'name_ku') required final String nameKu,
    final double multiplier,
    @JsonKey(name: 'delivery_days_offset') final int deliveryDaysOffset,
  }) = _$VehicleTypeImpl;

  factory _VehicleType.fromJson(Map<String, dynamic> json) =
      _$VehicleTypeImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'name_en')
  String get nameEn;
  @override
  @JsonKey(name: 'name_ku')
  String get nameKu;
  @override
  double get multiplier;
  @override
  @JsonKey(name: 'delivery_days_offset')
  int get deliveryDaysOffset;

  /// Create a copy of VehicleType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleTypeImplCopyWith<_$VehicleTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
