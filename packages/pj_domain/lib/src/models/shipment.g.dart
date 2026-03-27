// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShipmentImpl _$$ShipmentImplFromJson(Map<String, dynamic> json) =>
    _$ShipmentImpl(
      id: json['id'] as String,
      customerId: (json['customer_id'] as num).toInt(),
      driverId: (json['driver_id'] as num?)?.toInt(),
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      transitCountries: (json['transit_countries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      size: json['size'] as String?,
      categoryId: (json['category_id'] as num).toInt(),
      vehicleTypeId: (json['vehicle_type_id'] as num).toInt(),
      totalPrice: (json['total_price'] as num).toDouble(),
      estimatedDeliveryDays: (json['estimated_delivery_days'] as num).toInt(),
      status:
          $enumDecodeNullable(_$ShipmentStatusEnumMap, json['status']) ??
          ShipmentStatus.pending,
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      vehicleType: json['vehicle_type'] == null
          ? null
          : VehicleType.fromJson(json['vehicle_type'] as Map<String, dynamic>),
      priceBreakdown: json['price_breakdown'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ShipmentImplToJson(_$ShipmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer_id': instance.customerId,
      'driver_id': instance.driverId,
      'origin': instance.origin,
      'destination': instance.destination,
      'transit_countries': instance.transitCountries,
      'weight_kg': instance.weightKg,
      'size': instance.size,
      'category_id': instance.categoryId,
      'vehicle_type_id': instance.vehicleTypeId,
      'total_price': instance.totalPrice,
      'estimated_delivery_days': instance.estimatedDeliveryDays,
      'status': _$ShipmentStatusEnumMap[instance.status]!,
      'category': instance.category,
      'vehicle_type': instance.vehicleType,
      'price_breakdown': instance.priceBreakdown,
    };

const _$ShipmentStatusEnumMap = {
  ShipmentStatus.pending: 'pending',
  ShipmentStatus.inTransit: 'in_transit',
  ShipmentStatus.delivered: 'delivered',
  ShipmentStatus.reported: 'reported',
};
