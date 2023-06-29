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
      notification: json['notification'] as Map<String, dynamic>?,
      webPushFcmOptions: json['webPushFcmOptions'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$FirebaseWebpushConfigToJson(
        FirebaseWebpushConfig instance) =>
    <String, dynamic>{
      'headers': instance.headers,
      'data': instance.data,
      'notification': instance.notification,
      'webPushFcmOptions': instance.webPushFcmOptions,
    };
