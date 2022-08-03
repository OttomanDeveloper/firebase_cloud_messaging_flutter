import 'package:json_annotation/json_annotation.dart';

part 'apns.config.g.dart';

@JsonSerializable()
class FirebaseApnsConfig {
  final Map<String, String>? headers;
  final Map<String, String>? payload;

  factory FirebaseApnsConfig.fromJson(Map<String, dynamic> json) =>
      _$FirebaseApnsConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseApnsConfigToJson(this);

  const FirebaseApnsConfig({this.headers, this.payload});
}
