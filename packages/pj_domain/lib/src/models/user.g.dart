// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  deviceToken: json['device_token'] as String?,
  language: json['language'] as String? ?? 'en',
  theme: json['theme'] as String? ?? 'light',
  isActive: json['is_active'] as bool? ?? true,
  isOwner: json['isOwner'] as bool? ?? false,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role]!,
      'device_token': instance.deviceToken,
      'language': instance.language,
      'theme': instance.theme,
      'is_active': instance.isActive,
      'isOwner': instance.isOwner,
    };

const _$UserRoleEnumMap = {
  UserRole.customer: 'customer',
  UserRole.driver: 'driver',
  UserRole.staff: 'staff',
  UserRole.superAdmin: 'super_admin',
};
