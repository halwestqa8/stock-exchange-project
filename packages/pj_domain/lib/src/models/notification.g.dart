// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationImpl _$$NotificationImplFromJson(Map<String, dynamic> json) =>
    _$NotificationImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      messageEn: json['message_en'] as String,
      messageKu: json['message_ku'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      isRead: json['is_read'] as bool? ?? false,
      imageUrl: json['image_url'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$$NotificationImplToJson(_$NotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'message_en': instance.messageEn,
      'message_ku': instance.messageKu,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'is_read': instance.isRead,
      'image_url': instance.imageUrl,
      'location': instance.location,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.statusUpdate: 'status_update',
  NotificationType.reportUpdate: 'report_update',
  NotificationType.assignment: 'assignment',
};
