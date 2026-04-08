// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webpush_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebpushAction _$WebpushActionFromJson(Map<String, dynamic> json) =>
    WebpushAction(
      action: json['action'] as String?,
      title: json['title'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$WebpushActionToJson(WebpushAction instance) =>
    <String, dynamic>{
      if (instance.action != null) 'action': instance.action,
      if (instance.title != null) 'title': instance.title,
      if (instance.icon != null) 'icon': instance.icon,
    };

FirebaseWebpushNotification _$FirebaseWebpushNotificationFromJson(
        Map<String, dynamic> json) =>
    FirebaseWebpushNotification(
      title: json['title'] as String?,
      body: json['body'] as String?,
      icon: json['icon'] as String?,
      badge: json['badge'] as String?,
      image: json['image'] as String?,
      tag: json['tag'] as String?,
      vibrate: (json['vibrate'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      requireInteraction: json['require_interaction'] as bool?,
      silent: json['silent'] as bool?,
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => WebpushAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      dir: $enumDecodeNullable(_$WebpushDirectionEnumMap, json['dir']),
      lang: json['lang'] as String?,
      renotify: json['renotify'] as bool?,
      timestamp: json['timestamp'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$FirebaseWebpushNotificationToJson(
        FirebaseWebpushNotification instance) =>
    <String, dynamic>{
      if (instance.title != null) 'title': instance.title,
      if (instance.body != null) 'body': instance.body,
      if (instance.icon != null) 'icon': instance.icon,
      if (instance.badge != null) 'badge': instance.badge,
      if (instance.image != null) 'image': instance.image,
      if (instance.tag != null) 'tag': instance.tag,
      if (instance.vibrate != null) 'vibrate': instance.vibrate,
      if (instance.requireInteraction != null)
        'require_interaction': instance.requireInteraction,
      if (instance.silent != null) 'silent': instance.silent,
      if (instance.actions != null)
        'actions': instance.actions?.map((e) => e.toJson()).toList(),
      if (instance.dir != null) 'dir': _$WebpushDirectionEnumMap[instance.dir],
      if (instance.lang != null) 'lang': instance.lang,
      if (instance.renotify != null) 'renotify': instance.renotify,
      if (instance.timestamp != null) 'timestamp': instance.timestamp,
      if (instance.data != null) 'data': instance.data,
    };

const _$WebpushDirectionEnumMap = {
  WebpushDirection.auto: 'auto',
  WebpushDirection.ltr: 'ltr',
  WebpushDirection.rtl: 'rtl',
};

WebpushFcmOptions _$WebpushFcmOptionsFromJson(Map<String, dynamic> json) =>
    WebpushFcmOptions(
      link: json['link'] as String?,
      analyticsLabel: json['analytics_label'] as String?,
    );

Map<String, dynamic> _$WebpushFcmOptionsToJson(WebpushFcmOptions instance) =>
    <String, dynamic>{
      if (instance.link != null) 'link': instance.link,
      if (instance.analyticsLabel != null)
        'analytics_label': instance.analyticsLabel,
    };
