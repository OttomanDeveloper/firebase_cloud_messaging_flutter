// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'android.notification.dart';

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
    );

Map<String, dynamic> _$FirebaseAndroidNotificationToJson(
        FirebaseAndroidNotification instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'icon': instance.icon,
      'color': instance.color,
      'sound': instance.sound,
      'tag': instance.tag,
      'click_action': instance.clickAction,
      'body_loc_key': instance.bodyLocKey,
      'body_loc_args': instance.bodyLocArgs,
      'title_loc_key': instance.titleLocKey,
      'title_loc_args': instance.titleLocArgs,
      'channel_id': instance.channelID,
      'ticker': instance.ticker,
      'sticky': instance.sticky,
      'event_time': instance.eventTime,
      'local_only': instance.localOnly,
      'notification_priority':
          _$NotificationPriorityEnumMap[instance.notificationPriority],
      'default_sound': instance.defaultSound,
      'default_vibrate_timings': instance.defaultVibrateTimings,
      'default_light_settings': instance.defaultLightSettings,
      'vibrate_timings': instance.vibrateTimings,
      'visibility': _$VisibilityEnumMap[instance.visibility],
      'notification_count': instance.notificationCount,
      'light_settings': instance.lightSettings,
      'image': instance.image,
    };

const _$VisibilityEnumMap = {
  Visibility.VISIBILITY_UNSPECIFIED: 'VISIBILITY_UNSPECIFIED',
  Visibility.PRIVATE: 'PRIVATE',
  Visibility.PUBLIC: 'PUBLIC',
  Visibility.SECRET: 'SECRET',
};

const _$NotificationPriorityEnumMap = {
  NotificationPriority.PRIORITY_UNSPECIFIED: 'PRIORITY_UNSPECIFIED',
  NotificationPriority.PRIORITY_MIN: 'PRIORITY_MIN',
  NotificationPriority.PRIORITY_LOW: 'PRIORITY_LOW',
  NotificationPriority.PRIORITY_DEFAULT: 'PRIORITY_DEFAULT',
  NotificationPriority.PRIORITY_HIGH: 'PRIORITY_HIGH',
  NotificationPriority.PRIORITY_MAX: 'PRIORITY_MAX',
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
