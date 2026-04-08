// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apns_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApnsAlert _$ApnsAlertFromJson(Map<String, dynamic> json) => ApnsAlert(
      title: json['title'] as String?,
      titleLocKey: json['title-loc-key'] as String?,
      titleLocArgs: (json['title-loc-args'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      subtitle: json['subtitle'] as String?,
      body: json['body'] as String?,
      locKey: json['loc-key'] as String?,
      locArgs: (json['loc-args'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ApnsAlertToJson(ApnsAlert instance) => <String, dynamic>{
      'title': instance.title,
      'title-loc-key': instance.titleLocKey,
      'title-loc-args': instance.titleLocArgs,
      'subtitle': instance.subtitle,
      'body': instance.body,
      'loc-key': instance.locKey,
      'loc-args': instance.locArgs,
    };

FirebaseApnsNotification _$FirebaseApnsNotificationFromJson(
        Map<String, dynamic> json) =>
    FirebaseApnsNotification(
      alert: json['alert'] == null
          ? null
          : ApnsAlert.fromJson(json['alert'] as Map<String, dynamic>),
      title: json['title'] as String?,
      body: json['body'] as String?,
      sound: json['sound'] as String?,
      badge: (json['badge'] as num?)?.toInt(),
      category: json['category'] as String?,
      threadId: json['thread-id'] as String?,
      contentAvailable: (json['content-available'] as num?)?.toInt(),
      mutableContent: (json['mutable-content'] as num?)?.toInt(),
      targetContentId: json['target-content-id'] as String?,
      interruptionLevel: $enumDecodeNullable(
          _$InterruptionLevelEnumMap, json['interruption-level']),
      relevanceScore: (json['relevance-score'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FirebaseApnsNotificationToJson(
        FirebaseApnsNotification instance) =>
    <String, dynamic>{
      'alert': instance.alert,
      'title': instance.title,
      'body': instance.body,
      'sound': instance.sound,
      'badge': instance.badge,
      'category': instance.category,
      'thread-id': instance.threadId,
      'content-available': instance.contentAvailable,
      'mutable-content': instance.mutableContent,
      'target-content-id': instance.targetContentId,
      'interruption-level':
          _$InterruptionLevelEnumMap[instance.interruptionLevel],
      'relevance-score': instance.relevanceScore,
    };

const _$InterruptionLevelEnumMap = {
  InterruptionLevel.active: 'active',
  InterruptionLevel.critical: 'critical',
  InterruptionLevel.passive: 'passive',
  InterruptionLevel.timeSensitive: 'time-sensitive',
};

ApnsFcmOptions _$ApnsFcmOptionsFromJson(Map<String, dynamic> json) =>
    ApnsFcmOptions(
      analyticsLabel: json['analytics_label'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ApnsFcmOptionsToJson(ApnsFcmOptions instance) =>
    <String, dynamic>{
      'analytics_label': instance.analyticsLabel,
      'image': instance.image,
    };
