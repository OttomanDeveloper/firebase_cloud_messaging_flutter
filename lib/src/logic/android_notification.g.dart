// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'android_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseAndroidNotification _$FirebaseAndroidNotificationFromJson(
        Map<String, dynamic> json) =>
    FirebaseAndroidNotification(
      title: json['title'] as String?,
      body: json['body'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      sound: json['sound'] as String?,
      tag: json['tag'] as String?,
      ticker: json['ticker'] as String?,
      sticky: json['sticky'] as bool?,
      visibility: $enumDecodeNullable(_$VisibilityEnumMap, json['visibility']),
      image: json['image'] as String?,
      clickAction: json['click_action'] as String?,
      bodyLocKey: json['body_loc_key'] as String?,
      bodyLocArgs: (json['body_loc_args'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      titleLocKey: json['title_loc_key'] as String?,
      titleLocArgs: (json['title_loc_args'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      channelID: json['channel_id'] as String?,
      eventTime: json['event_time'] as String?,
      localOnly: json['local_only'] as bool?,
      notificationPriority: $enumDecodeNullable(
          _$NotificationPriorityEnumMap, json['notification_priority']),
      defaultSound: json['default_sound'] as bool?,
      defaultVibrateTimings: json['default_vibrate_timings'] as bool?,
      defaultLightSettings: json['default_light_settings'] as bool?,
      vibrateTimings: (json['vibrate_timings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      notificationCount: json['notification_count'] as int?,
      lightSettings: json['light_settings'] == null
          ? null
          : LightSettings.fromJson(
              json['light_settings'] as Map<String, dynamic>),
      proxy:
          $enumDecodeNullable(_$AndroidNotificationProxyEnumMap, json['proxy']),
    );

Map<String, dynamic> _$FirebaseAndroidNotificationToJson(
        FirebaseAndroidNotification instance) =>
    <String, dynamic>{
      if (instance.title != null) 'title': instance.title,
      if (instance.body != null) 'body': instance.body,
      if (instance.icon != null) 'icon': instance.icon,
      if (instance.color != null) 'color': instance.color,
      if (instance.sound != null) 'sound': instance.sound,
      if (instance.tag != null) 'tag': instance.tag,
      if (instance.clickAction != null) 'click_action': instance.clickAction,
      if (instance.bodyLocKey != null) 'body_loc_key': instance.bodyLocKey,
      if (instance.bodyLocArgs != null) 'body_loc_args': instance.bodyLocArgs,
      if (instance.titleLocKey != null) 'title_loc_key': instance.titleLocKey,
      if (instance.titleLocArgs != null)
        'title_loc_args': instance.titleLocArgs,
      if (instance.channelID != null) 'channel_id': instance.channelID,
      if (instance.ticker != null) 'ticker': instance.ticker,
      if (instance.sticky != null) 'sticky': instance.sticky,
      if (instance.eventTime != null) 'event_time': instance.eventTime,
      if (instance.localOnly != null) 'local_only': instance.localOnly,
      if (instance.notificationPriority != null)
        'notification_priority':
            _$NotificationPriorityEnumMap[instance.notificationPriority],
      if (instance.defaultSound != null) 'default_sound': instance.defaultSound,
      if (instance.defaultVibrateTimings != null)
        'default_vibrate_timings': instance.defaultVibrateTimings,
      if (instance.defaultLightSettings != null)
        'default_light_settings': instance.defaultLightSettings,
      if (instance.vibrateTimings != null)
        'vibrate_timings': instance.vibrateTimings,
      if (instance.visibility != null)
        'visibility': _$VisibilityEnumMap[instance.visibility],
      if (instance.notificationCount != null)
        'notification_count': instance.notificationCount,
      if (instance.lightSettings != null)
        'light_settings': instance.lightSettings?.toJson(),
      if (instance.image != null) 'image': instance.image,
      if (instance.proxy != null)
        'proxy': _$AndroidNotificationProxyEnumMap[instance.proxy],
    };

const _$AndroidNotificationProxyEnumMap = {
  AndroidNotificationProxy.proxyUnspecified: 'PROXY_UNSPECIFIED',
  AndroidNotificationProxy.allow: 'ALLOW',
  AndroidNotificationProxy.deny: 'DENY',
  AndroidNotificationProxy.ifPriorityDegraded: 'IF_PRIORITY_DEGRADED',
};

const _$VisibilityEnumMap = {
  Visibility.visibilityUnspecified: 'VISIBILITY_UNSPECIFIED',
  Visibility.private: 'PRIVATE',
  Visibility.public: 'PUBLIC',
  Visibility.secret: 'SECRET',
};

const _$NotificationPriorityEnumMap = {
  NotificationPriority.priorityUnspecified: 'PRIORITY_UNSPECIFIED',
  NotificationPriority.priorityMin: 'PRIORITY_MIN',
  NotificationPriority.priorityLow: 'PRIORITY_LOW',
  NotificationPriority.priorityDefault: 'PRIORITY_DEFAULT',
  NotificationPriority.priorityHigh: 'PRIORITY_HIGH',
  NotificationPriority.priorityMax: 'PRIORITY_MAX',
};

LightSettings _$LightSettingsFromJson(Map<String, dynamic> json) =>
    LightSettings(
      color: json['color'] == null
          ? null
          : FCMColor.fromJson(json['color'] as Map<String, dynamic>),
      lightOnDuration: json['light_on_duration'] as String?,
      lightOffDuration: json['light_off_duration'] as String?,
    );

Map<String, dynamic> _$LightSettingsToJson(LightSettings instance) =>
    <String, dynamic>{
      'color': instance.color,
      'light_on_duration': instance.lightOnDuration,
      'light_off_duration': instance.lightOffDuration,
    };

FCMColor _$FCMColorFromJson(Map<String, dynamic> json) => FCMColor(
      red: json['red'] as int?,
      green: json['green'] as int?,
      blue: json['blue'] as int?,
      alpha: json['alpha'] as int?,
    );

Map<String, dynamic> _$FCMColorToJson(FCMColor instance) => <String, dynamic>{
      'red': instance.red,
      'green': instance.green,
      'blue': instance.blue,
      'alpha': instance.alpha,
    };
