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
      'action': instance.action,
      'title': instance.title,
      'icon': instance.icon,
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
      'title': instance.title,
      'body': instance.body,
      'icon': instance.icon,
      'badge': instance.badge,
      'image': instance.image,
      'tag': instance.tag,
      'vibrate': instance.vibrate,
      'require_interaction': instance.requireInteraction,
      'silent': instance.silent,
      'actions': instance.actions,
      'dir': _$WebpushDirectionEnumMap[instance.dir],
      'lang': instance.lang,
      'renotify': instance.renotify,
      'timestamp': instance.timestamp,
      'data': instance.data,
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
      'link': instance.link,
      'analytics_label': instance.analyticsLabel,
    };
