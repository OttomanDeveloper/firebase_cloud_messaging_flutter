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
      if (instance.title != null) 'title': instance.title,
      if (instance.titleLocKey != null) 'title-loc-key': instance.titleLocKey,
      if (instance.titleLocArgs != null)
        'title-loc-args': instance.titleLocArgs,
      if (instance.subtitle != null) 'subtitle': instance.subtitle,
      if (instance.body != null) 'body': instance.body,
      if (instance.locKey != null) 'loc-key': instance.locKey,
      if (instance.locArgs != null) 'loc-args': instance.locArgs,
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
      badge: json['badge'] as int?,
      category: json['category'] as String?,
      threadId: json['thread-id'] as String?,
      contentAvailable: json['content-available'] as int?,
      mutableContent: json['mutable-content'] as int?,
      targetContentId: json['target-content-id'] as String?,
      interruptionLevel: $enumDecodeNullable(
          _$InterruptionLevelEnumMap, json['interruption-level']),
      relevanceScore: (json['relevance-score'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FirebaseApnsNotificationToJson(
        FirebaseApnsNotification instance) =>
    <String, dynamic>{
      if (instance.alert != null) 'alert': instance.alert?.toJson(),
      if (instance.title != null) 'title': instance.title,
      if (instance.body != null) 'body': instance.body,
      if (instance.sound != null) 'sound': instance.sound,
      if (instance.badge != null) 'badge': instance.badge,
      if (instance.category != null) 'category': instance.category,
      if (instance.threadId != null) 'thread-id': instance.threadId,
      if (instance.contentAvailable != null)
        'content-available': instance.contentAvailable,
      if (instance.mutableContent != null)
        'mutable-content': instance.mutableContent,
      if (instance.targetContentId != null)
        'target-content-id': instance.targetContentId,
      if (instance.interruptionLevel != null)
        'interruption-level':
            _$InterruptionLevelEnumMap[instance.interruptionLevel],
      if (instance.relevanceScore != null)
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
      if (instance.analyticsLabel != null)
        'analytics_label': instance.analyticsLabel,
      if (instance.image != null) 'image': instance.image,
    };
