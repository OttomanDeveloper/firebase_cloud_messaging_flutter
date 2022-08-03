import 'package:json_annotation/json_annotation.dart';

part 'webpush.config.g.dart';

@JsonSerializable()
class FirebaseWebpushConfig {
  final Map<String, String>? headers;
  final Map<String, String>? data;
  final Map<String, String>? notification;

  factory FirebaseWebpushConfig.fromJson(Map<String, dynamic> json) =>
      _$FirebaseWebpushConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseWebpushConfigToJson(this);

  const FirebaseWebpushConfig({this.headers, this.data, this.notification});
}
