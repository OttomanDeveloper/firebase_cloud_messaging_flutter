// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apns.config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseApnsConfig _$FirebaseApnsConfigFromJson(Map<String, dynamic> json) =>
    FirebaseApnsConfig(
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      payload: (json['payload'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$FirebaseApnsConfigToJson(FirebaseApnsConfig instance) =>
    <String, dynamic>{
      'headers': instance.headers,
      'payload': instance.payload,
    };
