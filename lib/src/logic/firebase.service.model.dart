import 'package:json_annotation/json_annotation.dart';

part 'firebase.service.model.g.dart';

@JsonSerializable()
class FirebaseServiceModel {
  final String? client_x509_cert_url;
  final String? type, project_id, private_key_id, private_key, client_email;
  final String? client_id, auth_uri, token_uri, auth_provider_x509_cert_url;

  factory FirebaseServiceModel.fromJson(Map<String, dynamic> json) =>
      _$FirebaseServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseServiceModelToJson(this);

  FirebaseServiceModel({
    this.client_x509_cert_url,
    this.type,
    this.project_id,
    this.private_key_id,
    this.private_key,
    this.client_email,
    this.client_id,
    this.auth_uri,
    this.token_uri,
    this.auth_provider_x509_cert_url,
  });
}
