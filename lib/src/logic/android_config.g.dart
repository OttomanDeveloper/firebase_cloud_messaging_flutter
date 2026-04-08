// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'android_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseAndroidConfig _$FirebaseAndroidConfigFromJson(
        Map<String, dynamic> json) =>
    FirebaseAndroidConfig(
      collapseKey: json['collapse_key'] as String?,
      priority: $enumDecodeNullable(
          _$AndroidMessagePriorityEnumMap, json['priority']),
      ttl: json['ttl'] as String?,
      restrictedPackageName: json['restricted_package_name'] as String?,
      data: (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      notification: json['notification'] == null
          ? null
          : FirebaseAndroidNotification.fromJson(
              json['notification'] as Map<String, dynamic>),
      directBootOk: json['direct_boot_ok'] as bool?,
    );

Map<String, dynamic> _$FirebaseAndroidConfigToJson(
        FirebaseAndroidConfig instance) =>
    <String, dynamic>{
      'collapse_key': instance.collapseKey,
      'priority': _$AndroidMessagePriorityEnumMap[instance.priority],
      'ttl': instance.ttl,
      'restricted_package_name': instance.restrictedPackageName,
      'data': instance.data,
      'notification': instance.notification,
      'direct_boot_ok': instance.directBootOk,
    };

const _$AndroidMessagePriorityEnumMap = {
  AndroidMessagePriority.normal: 'NORMAL',
  AndroidMessagePriority.high: 'HIGH',
};
