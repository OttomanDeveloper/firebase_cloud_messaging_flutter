import 'package:json_annotation/json_annotation.dart';
import 'message.dart';

part 'send.g.dart';

@JsonSerializable()
class FirebaseSend {
  bool? validate_only;
  FirebaseMessage? message;

  factory FirebaseSend.fromJson(Map<String, dynamic> json) =>
      _$FirebaseSendFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseSendToJson(this);

  FirebaseSend({this.validate_only = false, this.message});
}
