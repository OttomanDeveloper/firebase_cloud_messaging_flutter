import 'apns.notification.dart';
import 'package:json_annotation/json_annotation.dart';

part 'apns.config.g.dart';

/// Configuration for messages sent through the
/// Apple Push Notification Service (APNs) channel.
///
/// You can either use the typed [notification] and [fcmOptions] fields
/// (recommended) or supply a raw [payload] map for advanced APS dictionary
/// customisation. If both are provided, FCM merges them with the typed fields
/// taking precedence.
///
/// FCM Reference:
/// https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages#apnsconfig
@JsonSerializable()
class FirebaseApnsConfig {
  /// HTTP request headers defined in the APNs request.
  ///
  /// Refer to the APNs request headers documentation for supported header keys.
  /// Example: `{'apns-priority': '10', 'apns-expiration': '1604750400'}`.
  final Map<String, String>? headers;

  /// Typed structured iOS notification content (recommended).
  ///
  /// Replaces the previous raw [payload] Map for most use cases.
  /// The data is serialised into the APNs `aps` dictionary by FCM.
  final FirebaseApnsNotification? notification;

  /// FCM-specific options that overlay on the APNs delivery channel.
  @JsonKey(name: 'fcm_options')
  final ApnsFcmOptions? fcmOptions;

  /// A raw APS dictionary payload for advanced use cases not covered by
  /// the typed [notification] field.
  ///
  /// Use this only when you need low-level APNs control. For most scenarios
  /// prefer the structured [notification] field.
  ///
  /// An object containing a list of "key": value pairs.
  final Map<String, dynamic>? payload;

  const FirebaseApnsConfig({
    this.headers,
    this.notification,
    this.fcmOptions,
    this.payload,
  });

  factory FirebaseApnsConfig.fromJson(Map<String, dynamic> json) =>
      _$FirebaseApnsConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseApnsConfigToJson(this);
}
