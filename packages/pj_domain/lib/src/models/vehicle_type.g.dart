// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleTypeImpl _$$VehicleTypeImplFromJson(Map<String, dynamic> json) =>
    _$VehicleTypeImpl(
      id: (json['id'] as num).toInt(),
      nameEn: json['name_en'] as String,
      nameKu: json['name_ku'] as String,
      multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.0,
      deliveryDaysOffset: (json['delivery_days_offset'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$VehicleTypeImplToJson(_$VehicleTypeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_en': instance.nameEn,
      'name_ku': instance.nameKu,
      'multiplier': instance.multiplier,
      'delivery_days_offset': instance.deliveryDaysOffset,
    };
