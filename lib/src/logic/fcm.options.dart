import 'package:json_annotation/json_annotation.dart';

part 'fcm.options.g.dart';

@JsonSerializable()
class FirebaseFcmOptions {
  @JsonKey(name: "analytics_label")
  final String? analyticsLabel;

  factory FirebaseFcmOptions.fromJson(Map<String, dynamic> json) =>
      _$FirebaseFcmOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseFcmOptionsToJson(this);

  const FirebaseFcmOptions({this.analyticsLabel});
}
