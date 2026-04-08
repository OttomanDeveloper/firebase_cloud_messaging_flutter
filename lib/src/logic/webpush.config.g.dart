// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webpush.config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseWebpushConfig _$FirebaseWebpushConfigFromJson(
        Map<String, dynamic> json) =>
    FirebaseWebpushConfig(
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      data: (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      notification: json['notification'] == null
          ? null
          : FirebaseWebpushNotification.fromJson(
              json['notification'] as Map<String, dynamic>),
      fcmOptions: json['fcm_options'] == null
          ? null
          : WebpushFcmOptions.fromJson(
              json['fcm_options'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FirebaseWebpushConfigToJson(
        FirebaseWebpushConfig instance) =>
    <String, dynamic>{
      if (instance.headers != null) 'headers': instance.headers,
      if (instance.data != null) 'data': instance.data,
      if (instance.notification != null)
        'notification': instance.notification?.toJson(),
      if (instance.fcmOptions != null)
        'fcm_options': instance.fcmOptions?.toJson(),
    };
