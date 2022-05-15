import 'package:json_annotation/json_annotation.dart';

part 'webpush.config.g.dart';

@JsonSerializable()
class FirebaseWebpushConfig {
  Map<String, String>? headers;
  Map<String, String>? data;
  Map<String, String>? notification;

  factory FirebaseWebpushConfig.fromJson(Map<String, dynamic> json) =>
      _$FirebaseWebpushConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseWebpushConfigToJson(this);

  FirebaseWebpushConfig({this.headers, this.data, this.notification});
}
