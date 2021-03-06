// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'android.config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseAndroidConfig _$FirebaseAndroidConfigFromJson(
        Map<String, dynamic> json) =>
    FirebaseAndroidConfig(
      collapse_key: json['collapse_key'] as String?,
      priority: $enumDecodeNullable(
          _$AndroidMessagePriorityEnumMap, json['priority']),
      ttl: json['ttl'] as String?,
      restricted_package_name: json['restricted_package_name'] as String?,
      data: (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      notification: json['notification'] == null
          ? null
          : FirebaseAndroidNotification.fromJson(
              json['notification'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FirebaseAndroidConfigToJson(
        FirebaseAndroidConfig instance) =>
    <String, dynamic>{
      'collapse_key': instance.collapse_key,
      'priority': _$AndroidMessagePriorityEnumMap[instance.priority],
      'ttl': instance.ttl,
      'restricted_package_name': instance.restricted_package_name,
      'data': instance.data,
      'notification': instance.notification,
    };

const _$AndroidMessagePriorityEnumMap = {
  AndroidMessagePriority.NORMAL: 'NORMAL',
  AndroidMessagePriority.HIGH: 'HIGH',
};
