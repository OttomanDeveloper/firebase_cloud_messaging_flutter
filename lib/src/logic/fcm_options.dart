import 'package:json_annotation/json_annotation.dart';

part 'fcm_options.g.dart';

/// Cross-platform FCM options that apply regardless of the target channel
/// (Android, iOS, or Web).
///
/// FCM Reference:
/// https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages#fcmoptions
@JsonSerializable()
final class FirebaseFcmOptions {

  const FirebaseFcmOptions({this.analyticsLabel, this.image});

  factory FirebaseFcmOptions.fromJson(Map<String, dynamic> json) =>
      _$FirebaseFcmOptionsFromJson(json);
  /// A label associated with the message for use in Firebase Analytics.
  ///
  /// The label may only contain ASCII letters, numbers, and underscores;
  /// maximum length is 50 characters.
  @JsonKey(name: 'analytics_label')
  final String? analyticsLabel;

  /// URL of an image to be displayed in the notification.
  ///
  /// This overrides the image set in [FirebaseNotification.image] and applies
  /// across all platforms that support notification images.
  final String? image;

  Map<String, dynamic> toJson() => _$FirebaseFcmOptionsToJson(this);
}
