// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Shipment _$ShipmentFromJson(Map<String, dynamic> json) {
  return _Shipment.fromJson(json);
}

/// @nodoc
mixin _$Shipment {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  int get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_id')
  int? get driverId => throw _privateConstructorUsedError;
  String get origin => throw _privateConstructorUsedError;
  String get destination => throw _privateConstructorUsedError;
  @JsonKey(name: 'transit_countries')
  List<String>? get transitCountries => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_kg')
  double? get weightKg => throw _privateConstructorUsedError;
  @JsonKey(name: 'size')
  String? get size => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  int get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_type_id')
  int get vehicleTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_price')
  double get totalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_delivery_days')
  int get estimatedDeliveryDays => throw _privateConstructorUsedError;
  ShipmentStatus get status => throw _privateConstructorUsedError;
  Category? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_type')
  VehicleType? get vehicleType => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_breakdown')
  Map<String, dynamic>? get priceBreakdown =>
      throw _privateConstructorUsedError;

  /// Serializes this Shipment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentCopyWith<Shipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentCopyWith<$Res> {
  factory $ShipmentCopyWith(Shipment value, $Res Function(Shipment) then) =
      _$ShipmentCopyWithImpl<$Res, Shipment>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'customer_id') int customerId,
    @JsonKey(name: 'driver_id') int? driverId,
    String origin,
    String destination,
    @JsonKey(name: 'transit_countries') List<String>? transitCountries,
    @JsonKey(name: 'weight_kg') double? weightKg,
    @JsonKey(name: 'size') String? size,
    @JsonKey(name: 'category_id') int categoryId,
    @JsonKey(name: 'vehicle_type_id') int vehicleTypeId,
    @JsonKey(name: 'total_price') double totalPrice,
    @JsonKey(name: 'estimated_delivery_days') int estimatedDeliveryDays,
    ShipmentStatus status,
    Category? category,
    @JsonKey(name: 'vehicle_type') VehicleType? vehicleType,
    @JsonKey(name: 'price_breakdown') Map<String, dynamic>? priceBreakdown,
  });

  $CategoryCopyWith<$Res>? get category;
  $VehicleTypeCopyWith<$Res>? get vehicleType;
}

/// @nodoc
class _$ShipmentCopyWithImpl<$Res, $Val extends Shipment>
    implements $ShipmentCopyWith<$Res> {
  _$ShipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? driverId = freezed,
    Object? origin = null,
    Object? destination = null,
    Object? transitCountries = freezed,
    Object? weightKg = freezed,
    Object? size = freezed,
    Object? categoryId = null,
    Object? vehicleTypeId = null,
    Object? totalPrice = null,
    Object? estimatedDeliveryDays = null,
    Object? status = null,
    Object? category = freezed,
    Object? vehicleType = freezed,
    Object? priceBreakdown = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as int,
            driverId: freezed == driverId
                ? _value.driverId
                : driverId // ignore: cast_nullable_to_non_nullable
                      as int?,
            origin: null == origin
                ? _value.origin
                : origin // ignore: cast_nullable_to_non_nullable
                      as String,
            destination: null == destination
                ? _value.destination
                : destination // ignore: cast_nullable_to_non_nullable
                      as String,
            transitCountries: freezed == transitCountries
                ? _value.transitCountries
                : transitCountries // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            weightKg: freezed == weightKg
                ? _value.weightKg
                : weightKg // ignore: cast_nullable_to_non_nullable
                      as double?,
            size: freezed == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            vehicleTypeId: null == vehicleTypeId
                ? _value.vehicleTypeId
                : vehicleTypeId // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            estimatedDeliveryDays: null == estimatedDeliveryDays
                ? _value.estimatedDeliveryDays
                : estimatedDeliveryDays // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ShipmentStatus,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as Category?,
            vehicleType: freezed == vehicleType
                ? _value.vehicleType
                : vehicleType // ignore: cast_nullable_to_non_nullable
                      as VehicleType?,
            priceBreakdown: freezed == priceBreakdown
                ? _value.priceBreakdown
                : priceBreakdown // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VehicleTypeCopyWith<$Res>? get vehicleType {
    if (_value.vehicleType == null) {
      return null;
    }

    return $VehicleTypeCopyWith<$Res>(_value.vehicleType!, (value) {
      return _then(_value.copyWith(vehicleType: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShipmentImplCopyWith<$Res>
    implements $ShipmentCopyWith<$Res> {
  factory _$$ShipmentImplCopyWith(
    _$ShipmentImpl value,
    $Res Function(_$ShipmentImpl) then,
  ) = __$$ShipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'customer_id') int customerId,
    @JsonKey(name: 'driver_id') int? driverId,
    String origin,
    String destination,
    @JsonKey(name: 'transit_countries') List<String>? transitCountries,
    @JsonKey(name: 'weight_kg') double? weightKg,
    @JsonKey(name: 'size') String? size,
    @JsonKey(name: 'category_id') int categoryId,
    @JsonKey(name: 'vehicle_type_id') int vehicleTypeId,
    @JsonKey(name: 'total_price') double totalPrice,
    @JsonKey(name: 'estimated_delivery_days') int estimatedDeliveryDays,
    ShipmentStatus status,
    Category? category,
    @JsonKey(name: 'vehicle_type') VehicleType? vehicleType,
    @JsonKey(name: 'price_breakdown') Map<String, dynamic>? priceBreakdown,
  });

  @override
  $CategoryCopyWith<$Res>? get category;
  @override
  $VehicleTypeCopyWith<$Res>? get vehicleType;
}

/// @nodoc
class __$$ShipmentImplCopyWithImpl<$Res>
    extends _$ShipmentCopyWithImpl<$Res, _$ShipmentImpl>
    implements _$$ShipmentImplCopyWith<$Res> {
  __$$ShipmentImplCopyWithImpl(
    _$ShipmentImpl _value,
    $Res Function(_$ShipmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? driverId = freezed,
    Object? origin = null,
    Object? destination = null,
    Object? transitCountries = freezed,
    Object? weightKg = freezed,
    Object? size = freezed,
    Object? categoryId = null,
    Object? vehicleTypeId = null,
    Object? totalPrice = null,
    Object? estimatedDeliveryDays = null,
    Object? status = null,
    Object? category = freezed,
    Object? vehicleType = freezed,
    Object? priceBreakdown = freezed,
  }) {
    return _then(
      _$ShipmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as int,
        driverId: freezed == driverId
            ? _value.driverId
            : driverId // ignore: cast_nullable_to_non_nullable
                  as int?,
        origin: null == origin
            ? _value.origin
            : origin // ignore: cast_nullable_to_non_nullable
                  as String,
        destination: null == destination
            ? _value.destination
            : destination // ignore: cast_nullable_to_non_nullable
                  as String,
        transitCountries: freezed == transitCountries
            ? _value._transitCountries
            : transitCountries // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        weightKg: freezed == weightKg
            ? _value.weightKg
            : weightKg // ignore: cast_nullable_to_non_nullable
                  as double?,
        size: freezed == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        vehicleTypeId: null == vehicleTypeId
            ? _value.vehicleTypeId
            : vehicleTypeId // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        estimatedDeliveryDays: null == estimatedDeliveryDays
            ? _value.estimatedDeliveryDays
            : estimatedDeliveryDays // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ShipmentStatus,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as Category?,
        vehicleType: freezed == vehicleType
            ? _value.vehicleType
            : vehicleType // ignore: cast_nullable_to_non_nullable
                  as VehicleType?,
        priceBreakdown: freezed == priceBreakdown
            ? _value._priceBreakdown
            : priceBreakdown // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShipmentImpl implements _Shipment {
  const _$ShipmentImpl({
    required this.id,
    @JsonKey(name: 'customer_id') required this.customerId,
    @JsonKey(name: 'driver_id') this.driverId,
    required this.origin,
    required this.destination,
    @JsonKey(name: 'transit_countries') final List<String>? transitCountries,
    @JsonKey(name: 'weight_kg') this.weightKg,
    @JsonKey(name: 'size') this.size,
    @JsonKey(name: 'category_id') required this.categoryId,
    @JsonKey(name: 'vehicle_type_id') required this.vehicleTypeId,
    @JsonKey(name: 'total_price') required this.totalPrice,
    @JsonKey(name: 'estimated_delivery_days')
    required this.estimatedDeliveryDays,
    this.status = ShipmentStatus.pending,
    this.category,
    @JsonKey(name: 'vehicle_type') this.vehicleType,
    @JsonKey(name: 'price_breakdown')
    final Map<String, dynamic>? priceBreakdown,
  }) : _transitCountries = transitCountries,
       _priceBreakdown = priceBreakdown;

  factory _$ShipmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShipmentImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'customer_id')
  final int customerId;
  @override
  @JsonKey(name: 'driver_id')
  final int? driverId;
  @override
  final String origin;
  @override
  final String destination;
  final List<String>? _transitCountries;
  @override
  @JsonKey(name: 'transit_countries')
  List<String>? get transitCountries {
    final value = _transitCountries;
    if (value == null) return null;
    if (_transitCountries is EqualUnmodifiableListView)
      return _transitCountries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'weight_kg')
  final double? weightKg;
  @override
  @JsonKey(name: 'size')
  final String? size;
  @override
  @JsonKey(name: 'category_id')
  final int categoryId;
  @override
  @JsonKey(name: 'vehicle_type_id')
  final int vehicleTypeId;
  @override
  @JsonKey(name: 'total_price')
  final double totalPrice;
  @override
  @JsonKey(name: 'estimated_delivery_days')
  final int estimatedDeliveryDays;
  @override
  @JsonKey()
  final ShipmentStatus status;
  @override
  final Category? category;
  @override
  @JsonKey(name: 'vehicle_type')
  final VehicleType? vehicleType;
  final Map<String, dynamic>? _priceBreakdown;
  @override
  @JsonKey(name: 'price_breakdown')
  Map<String, dynamic>? get priceBreakdown {
    final value = _priceBreakdown;
    if (value == null) return null;
    if (_priceBreakdown is EqualUnmodifiableMapView) return _priceBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Shipment(id: $id, customerId: $customerId, driverId: $driverId, origin: $origin, destination: $destination, transitCountries: $transitCountries, weightKg: $weightKg, size: $size, categoryId: $categoryId, vehicleTypeId: $vehicleTypeId, totalPrice: $totalPrice, estimatedDeliveryDays: $estimatedDeliveryDays, status: $status, category: $category, vehicleType: $vehicleType, priceBreakdown: $priceBreakdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            const DeepCollectionEquality().equals(
              other._transitCountries,
              _transitCountries,
            ) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.vehicleTypeId, vehicleTypeId) ||
                other.vehicleTypeId == vehicleTypeId) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.estimatedDeliveryDays, estimatedDeliveryDays) ||
                other.estimatedDeliveryDays == estimatedDeliveryDays) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            const DeepCollectionEquality().equals(
              other._priceBreakdown,
              _priceBreakdown,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    customerId,
    driverId,
    origin,
    destination,
    const DeepCollectionEquality().hash(_transitCountries),
    weightKg,
    size,
    categoryId,
    vehicleTypeId,
    totalPrice,
    estimatedDeliveryDays,
    status,
    category,
    vehicleType,
    const DeepCollectionEquality().hash(_priceBreakdown),
  );

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentImplCopyWith<_$ShipmentImpl> get copyWith =>
      __$$ShipmentImplCopyWithImpl<_$ShipmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShipmentImplToJson(this);
  }
}

abstract class _Shipment implements Shipment {
  const factory _Shipment({
    required final String id,
    @JsonKey(name: 'customer_id') required final int customerId,
    @JsonKey(name: 'driver_id') final int? driverId,
    required final String origin,
    required final String destination,
    @JsonKey(name: 'transit_countries') final List<String>? transitCountries,
    @JsonKey(name: 'weight_kg') final double? weightKg,
    @JsonKey(name: 'size') final String? size,
    @JsonKey(name: 'category_id') required final int categoryId,
    @JsonKey(name: 'vehicle_type_id') required final int vehicleTypeId,
    @JsonKey(name: 'total_price') required final double totalPrice,
    @JsonKey(name: 'estimated_delivery_days')
    required final int estimatedDeliveryDays,
    final ShipmentStatus status,
    final Category? category,
    @JsonKey(name: 'vehicle_type') final VehicleType? vehicleType,
    @JsonKey(name: 'price_breakdown')
    final Map<String, dynamic>? priceBreakdown,
  }) = _$ShipmentImpl;

  factory _Shipment.fromJson(Map<String, dynamic> json) =
      _$ShipmentImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'customer_id')
  int get customerId;
  @override
  @JsonKey(name: 'driver_id')
  int? get driverId;
  @override
  String get origin;
  @override
  String get destination;
  @override
  @JsonKey(name: 'transit_countries')
  List<String>? get transitCountries;
  @override
  @JsonKey(name: 'weight_kg')
  double? get weightKg;
  @override
  @JsonKey(name: 'size')
  String? get size;
  @override
  @JsonKey(name: 'category_id')
  int get categoryId;
  @override
  @JsonKey(name: 'vehicle_type_id')
  int get vehicleTypeId;
  @override
  @JsonKey(name: 'total_price')
  double get totalPrice;
  @override
  @JsonKey(name: 'estimated_delivery_days')
  int get estimatedDeliveryDays;
  @override
  ShipmentStatus get status;
  @override
  Category? get category;
  @override
  @JsonKey(name: 'vehicle_type')
  VehicleType? get vehicleType;
  @override
  @JsonKey(name: 'price_breakdown')
  Map<String, dynamic>? get priceBreakdown;

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentImplCopyWith<_$ShipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
