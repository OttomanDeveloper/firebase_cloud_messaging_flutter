// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apns_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseApnsConfig _$FirebaseApnsConfigFromJson(Map<String, dynamic> json) =>
    FirebaseApnsConfig(
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      notification: json['notification'] == null
          ? null
          : FirebaseApnsNotification.fromJson(
              json['notification'] as Map<String, dynamic>),
      fcmOptions: json['fcm_options'] == null
          ? null
          : ApnsFcmOptions.fromJson(
              json['fcm_options'] as Map<String, dynamic>),
      payload: json['payload'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$FirebaseApnsConfigToJson(FirebaseApnsConfig instance) =>
    <String, dynamic>{
      if (instance.headers != null) 'headers': instance.headers,
      if (instance.notification != null)
        'notification': instance.notification?.toJson(),
      if (instance.fcmOptions != null)
        'fcm_options': instance.fcmOptions?.toJson(),
      if (instance.payload != null) 'payload': instance.payload,
    };
