import 'package:json_annotation/json_annotation.dart';

import 'android.config.dart';
import 'apns.config.dart';
import 'fcm.options.dart';
import 'notification.dart';
import 'webpush.config.dart';

part 'message.g.dart';

@JsonSerializable()
class FirebaseMessage {
  ///Output Only. The identifier of the message sent, in the format of projects/*/messages/{message_id}.
  final String? name;

  ///Input only. Arbitrary key/value payload. The key should not be a reserved word ("from", "message_type", or any word starting with "google" or "gcm").
  //
  //An object containing a list of "key": value pairs. Example: { "name": "wrench", "mass": "1.3kg", "count": "3" }.
  final Map<String, String>? data;

  ///Input only. Basic notification template to use across all platforms.
  final FirebaseNotification? notification;

  ///Input only. Android specific options for messages sent through FCM connection server.
  final FirebaseAndroidConfig? android;
  final FirebaseWebpushConfig? webpush;
  final FirebaseApnsConfig? apns;

  @JsonKey(name: "fcm_options")
  final FirebaseFcmOptions? fcmOptions;

  /// Registration token to send a message to.
  // Union field target can be only one of the following:
  ///Union field target. Required. Input only. Target to send a message to. target can be only one of token, topic or condition.
  final String? token;

  /// Topic name to send a message to, e.g. "weather". Note: "/topics/" prefix should not be provided.
  // Union field target can be only one of the following:
  ///Union field target. Required. Input only. Target to send a message to. target can be only one of token, topic or condition.
  final String? topic;

  /// Condition to send a message to, e.g. "'foo' in topics && 'bar' in topics".
  // Union field target can be only one of the following:
  ///Union field target. Required. Input only. Target to send a message to. target can be only one of token, topic or condition.
  final String? condition;

  factory FirebaseMessage.fromJson(Map<String, dynamic> json) =>
      _$FirebaseMessageFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseMessageToJson(this);

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

  @override
  String toString() {
    return 'Message{name: $name, data: $data, notification: $notification, android: $android, webpush: $webpush, apns: $apns, fcm_options: $fcmOptions, token: $token, topic: $topic, condition: $condition}';
  }
}
