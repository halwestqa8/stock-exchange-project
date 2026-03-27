// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PricingConfigImpl _$$PricingConfigImplFromJson(Map<String, dynamic> json) =>
    _$PricingConfigImpl(
      id: (json['id'] as num).toInt(),
      basePrice: (json['base_price'] as num).toDouble(),
      weightRate: (json['weight_rate'] as num).toDouble(),
    );

Map<String, dynamic> _$$PricingConfigImplToJson(_$PricingConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'base_price': instance.basePrice,
      'weight_rate': instance.weightRate,
    };
