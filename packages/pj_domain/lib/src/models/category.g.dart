// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: (json['id'] as num).toInt(),
      nameEn: json['name_en'] as String,
      nameKu: json['name_ku'] as String,
      surcharge: (json['surcharge'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_en': instance.nameEn,
      'name_ku': instance.nameKu,
      'surcharge': instance.surcharge,
    };
