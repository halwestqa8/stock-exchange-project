// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportImpl _$$ReportImplFromJson(Map<String, dynamic> json) => _$ReportImpl(
  id: (json['id'] as num).toInt(),
  shipmentId: json['shipment_id'] as String,
  customerComment: json['customer_comment'] as String,
  staffResponse: json['staff_response'] as String?,
  status:
      $enumDecodeNullable(_$ReportStatusEnumMap, json['status']) ??
      ReportStatus.open,
  resolvedAt: json['resolved_at'] == null
      ? null
      : DateTime.parse(json['resolved_at'] as String),
);

Map<String, dynamic> _$$ReportImplToJson(_$ReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shipment_id': instance.shipmentId,
      'customer_comment': instance.customerComment,
      'staff_response': instance.staffResponse,
      'status': _$ReportStatusEnumMap[instance.status]!,
      'resolved_at': instance.resolvedAt?.toIso8601String(),
    };

const _$ReportStatusEnumMap = {
  ReportStatus.open: 'open',
  ReportStatus.resolved: 'resolved',
  ReportStatus.rejected: 'rejected',
  ReportStatus.compensationIssued: 'compensation_issued',
};
