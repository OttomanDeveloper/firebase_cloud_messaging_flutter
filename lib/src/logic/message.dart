import 'package:json_annotation/json_annotation.dart';

import 'android_config.dart';
import 'apns_config.dart';
import 'fcm_options.dart';
import 'notification.dart';
import 'webpush_config.dart';

part 'message.g.dart';

/// The core FCM message object.
///
/// Build a [FirebaseMessage] to describe exactly what the recipient device
/// should receive. You must supply exactly one of [token], [topic], or
/// [condition] to select the target audience.
///
/// FCM Reference:
/// https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages
@JsonSerializable()
class FirebaseMessage {
  /// Output-only identifier returned by FCM after a successful send.
  ///
  /// Format: `"projects/{project-id}/messages/{message-id}"`.
  final String? name;

  /// Arbitrary key/value payload delivered alongside the notification.
  ///
  /// Keys must not be reserved FCM words (`"from"`, `"message_type"`, or any
  /// word starting with `"google"` or `"gcm"`). All values must be strings.
  ///
  /// An object containing a list of "key": value pairs.
  final Map<String, String>? data;

  /// Cross-platform notification content.
  ///
  /// Values set here apply to all platforms; use [android], [apns], and
  /// [webpush] for platform-specific overrides.
  final FirebaseNotification? notification;

  /// Android-specific message configuration.
  final FirebaseAndroidConfig? android;

  /// Web-push–specific message configuration.
  final FirebaseWebpushConfig? webpush;

  /// Apple Push Notification Service (APNs) configuration.
  final FirebaseApnsConfig? apns;

  /// Cross-platform FCM options (analytics label, image).
  @JsonKey(name: 'fcm_options')
  final FirebaseFcmOptions? fcmOptions;

  // -- Target fields (only one should be set at a time) ----------------------

  /// Device registration token — use to send to a **single** device.
  ///
  /// Only one of [token], [topic], or [condition] may be set.
  final String? token;

  /// FCM topic name — use to fan out to all **topic subscribers**.
  ///
  /// Do NOT include the `"/topics/"` prefix — FCM adds it automatically.
  ///
  /// Only one of [token], [topic], or [condition] may be set.
  final String? topic;

  /// Boolean expression — use to send to devices matching a **condition**.
  ///
  /// Syntax: `"'topic1' in topics && 'topic2' in topics"`.
  ///
  /// Only one of [token], [topic], or [condition] may be set.
  final String? condition;

  const FirebaseMessage({
    this.name,
    this.data,
    this.notification,
    this.android,
    this.webpush,
    this.apns,
    this.fcmOptions,
    this.token,
    this.topic,
    this.condition,
  });

  factory FirebaseMessage.fromJson(Map<String, dynamic> json) =>
      _$FirebaseMessageFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseMessageToJson(this);

  /// Creates a copy of this [FirebaseMessage] with the specified fields replaced.
  ///
  /// Particularly useful in [sendToMultiple] and [sendToTopic] to stamp a
  /// target onto a shared message template without mutating the original.
  FirebaseMessage copyWith({
    String? name,
    Map<String, String>? data,
    FirebaseNotification? notification,
    FirebaseAndroidConfig? android,
    FirebaseWebpushConfig? webpush,
    FirebaseApnsConfig? apns,
    FirebaseFcmOptions? fcmOptions,
    String? token,
    String? topic,
    String? condition,
  }) {
    return FirebaseMessage(
      name: name ?? this.name,
      data: data ?? this.data,
      notification: notification ?? this.notification,
      android: android ?? this.android,
      webpush: webpush ?? this.webpush,
      apns: apns ?? this.apns,
      fcmOptions: fcmOptions ?? this.fcmOptions,
      token: token ?? this.token,
      topic: topic ?? this.topic,
      condition: condition ?? this.condition,
    );
  }

  @override
  String toString() {
    return 'FirebaseMessage{name: $name, data: $data, '
        'notification: $notification, android: $android, webpush: $webpush, '
        'apns: $apns, fcm_options: $fcmOptions, token: $token, '
        'topic: $topic, condition: $condition}';
  }
}
