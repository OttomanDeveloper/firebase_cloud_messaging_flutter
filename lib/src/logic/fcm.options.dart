import 'package:json_annotation/json_annotation.dart';

part 'fcm.options.g.dart';

@JsonSerializable()
class FirebaseFcmOptions {
  String? analytics_label;

  factory FirebaseFcmOptions.fromJson(Map<String, dynamic> json) =>
      _$FirebaseFcmOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseFcmOptionsToJson(this);

  FirebaseFcmOptions({this.analytics_label});
}
