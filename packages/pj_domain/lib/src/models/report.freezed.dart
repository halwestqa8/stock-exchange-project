// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Report _$ReportFromJson(Map<String, dynamic> json) {
  return _Report.fromJson(json);
}

/// @nodoc
mixin _$Report {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipment_id')
  String get shipmentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_comment')
  String get customerComment => throw _privateConstructorUsedError;
  @JsonKey(name: 'staff_response')
  String? get staffResponse => throw _privateConstructorUsedError;
  ReportStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'resolved_at')
  DateTime? get resolvedAt => throw _privateConstructorUsedError;

  /// Serializes this Report to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportCopyWith<Report> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportCopyWith<$Res> {
  factory $ReportCopyWith(Report value, $Res Function(Report) then) =
      _$ReportCopyWithImpl<$Res, Report>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'shipment_id') String shipmentId,
    @JsonKey(name: 'customer_comment') String customerComment,
    @JsonKey(name: 'staff_response') String? staffResponse,
    ReportStatus status,
    @JsonKey(name: 'resolved_at') DateTime? resolvedAt,
  });
}

/// @nodoc
class _$ReportCopyWithImpl<$Res, $Val extends Report>
    implements $ReportCopyWith<$Res> {
  _$ReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shipmentId = null,
    Object? customerComment = null,
    Object? staffResponse = freezed,
    Object? status = null,
    Object? resolvedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            shipmentId: null == shipmentId
                ? _value.shipmentId
                : shipmentId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerComment: null == customerComment
                ? _value.customerComment
                : customerComment // ignore: cast_nullable_to_non_nullable
                      as String,
            staffResponse: freezed == staffResponse
                ? _value.staffResponse
                : staffResponse // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ReportStatus,
            resolvedAt: freezed == resolvedAt
                ? _value.resolvedAt
                : resolvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportImplCopyWith<$Res> implements $ReportCopyWith<$Res> {
  factory _$$ReportImplCopyWith(
    _$ReportImpl value,
    $Res Function(_$ReportImpl) then,
  ) = __$$ReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'shipment_id') String shipmentId,
    @JsonKey(name: 'customer_comment') String customerComment,
    @JsonKey(name: 'staff_response') String? staffResponse,
    ReportStatus status,
    @JsonKey(name: 'resolved_at') DateTime? resolvedAt,
  });
}

/// @nodoc
class __$$ReportImplCopyWithImpl<$Res>
    extends _$ReportCopyWithImpl<$Res, _$ReportImpl>
    implements _$$ReportImplCopyWith<$Res> {
  __$$ReportImplCopyWithImpl(
    _$ReportImpl _value,
    $Res Function(_$ReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shipmentId = null,
    Object? customerComment = null,
    Object? staffResponse = freezed,
    Object? status = null,
    Object? resolvedAt = freezed,
  }) {
    return _then(
      _$ReportImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        shipmentId: null == shipmentId
            ? _value.shipmentId
            : shipmentId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerComment: null == customerComment
            ? _value.customerComment
            : customerComment // ignore: cast_nullable_to_non_nullable
                  as String,
        staffResponse: freezed == staffResponse
            ? _value.staffResponse
            : staffResponse // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ReportStatus,
        resolvedAt: freezed == resolvedAt
            ? _value.resolvedAt
            : resolvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportImpl implements _Report {
  const _$ReportImpl({
    required this.id,
    @JsonKey(name: 'shipment_id') required this.shipmentId,
    @JsonKey(name: 'customer_comment') required this.customerComment,
    @JsonKey(name: 'staff_response') this.staffResponse,
    this.status = ReportStatus.open,
    @JsonKey(name: 'resolved_at') this.resolvedAt,
  });

  factory _$ReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'shipment_id')
  final String shipmentId;
  @override
  @JsonKey(name: 'customer_comment')
  final String customerComment;
  @override
  @JsonKey(name: 'staff_response')
  final String? staffResponse;
  @override
  @JsonKey()
  final ReportStatus status;
  @override
  @JsonKey(name: 'resolved_at')
  final DateTime? resolvedAt;

  @override
  String toString() {
    return 'Report(id: $id, shipmentId: $shipmentId, customerComment: $customerComment, staffResponse: $staffResponse, status: $status, resolvedAt: $resolvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shipmentId, shipmentId) ||
                other.shipmentId == shipmentId) &&
            (identical(other.customerComment, customerComment) ||
                other.customerComment == customerComment) &&
            (identical(other.staffResponse, staffResponse) ||
                other.staffResponse == staffResponse) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    shipmentId,
    customerComment,
    staffResponse,
    status,
    resolvedAt,
  );

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportImplCopyWith<_$ReportImpl> get copyWith =>
      __$$ReportImplCopyWithImpl<_$ReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportImplToJson(this);
  }
}

abstract class _Report implements Report {
  const factory _Report({
    required final int id,
    @JsonKey(name: 'shipment_id') required final String shipmentId,
    @JsonKey(name: 'customer_comment') required final String customerComment,
    @JsonKey(name: 'staff_response') final String? staffResponse,
    final ReportStatus status,
    @JsonKey(name: 'resolved_at') final DateTime? resolvedAt,
  }) = _$ReportImpl;

  factory _Report.fromJson(Map<String, dynamic> json) = _$ReportImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'shipment_id')
  String get shipmentId;
  @override
  @JsonKey(name: 'customer_comment')
  String get customerComment;
  @override
  @JsonKey(name: 'staff_response')
  String? get staffResponse;
  @override
  ReportStatus get status;
  @override
  @JsonKey(name: 'resolved_at')
  DateTime? get resolvedAt;

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportImplCopyWith<_$ReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
