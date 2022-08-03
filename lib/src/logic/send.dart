import 'package:json_annotation/json_annotation.dart';
import 'message.dart';

part 'send.g.dart';

@JsonSerializable()
class FirebaseSend {
  @JsonKey(name: "validate_only")
  final bool? validateOnly;
  final FirebaseMessage? message;

  factory FirebaseSend.fromJson(Map<String, dynamic> json) =>
      _$FirebaseSendFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseSendToJson(this);

  const FirebaseSend({this.validateOnly = false, this.message});
}
