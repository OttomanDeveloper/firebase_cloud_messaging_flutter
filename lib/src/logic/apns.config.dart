import 'package:json_annotation/json_annotation.dart';

part 'apns.config.g.dart';

@JsonSerializable()
class FirebaseApnsConfig {
  Map<String, String>? headers;
  Map<String, String>? payload;

  factory FirebaseApnsConfig.fromJson(Map<String, dynamic> json) =>
      _$FirebaseApnsConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseApnsConfigToJson(this);

  FirebaseApnsConfig({this.headers, this.payload});
}
