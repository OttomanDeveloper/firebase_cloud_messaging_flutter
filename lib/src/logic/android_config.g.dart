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
      if (instance.collapseKey != null) 'collapse_key': instance.collapseKey,
      if (instance.priority != null)
        'priority': _$AndroidMessagePriorityEnumMap[instance.priority],
      if (instance.ttl != null) 'ttl': instance.ttl,
      if (instance.restrictedPackageName != null)
        'restricted_package_name': instance.restrictedPackageName,
      if (instance.data != null) 'data': instance.data,
      if (instance.notification != null)
        'notification': instance.notification?.toJson(),
      if (instance.directBootOk != null)
        'direct_boot_ok': instance.directBootOk,
    };

const _$AndroidMessagePriorityEnumMap = {
  AndroidMessagePriority.normal: 'NORMAL',
  AndroidMessagePriority.high: 'HIGH',
};
