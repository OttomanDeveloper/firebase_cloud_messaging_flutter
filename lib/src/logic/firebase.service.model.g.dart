// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase.service.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseServiceModel _$FirebaseServiceModelFromJson(
        Map<String, dynamic> json) =>
    FirebaseServiceModel(
      client_x509_cert_url: json['client_x509_cert_url'] as String?,
      type: json['type'] as String?,
      project_id: json['project_id'] as String?,
      private_key_id: json['private_key_id'] as String?,
      private_key: json['private_key'] as String?,
      client_email: json['client_email'] as String?,
      client_id: json['client_id'] as String?,
      auth_uri: json['auth_uri'] as String?,
      token_uri: json['token_uri'] as String?,
      auth_provider_x509_cert_url:
          json['auth_provider_x509_cert_url'] as String?,
    );

Map<String, dynamic> _$FirebaseServiceModelToJson(
        FirebaseServiceModel instance) =>
    <String, dynamic>{
      'client_x509_cert_url': instance.client_x509_cert_url,
      'type': instance.type,
      'project_id': instance.project_id,
      'private_key_id': instance.private_key_id,
      'private_key': instance.private_key,
      'client_email': instance.client_email,
      'client_id': instance.client_id,
      'auth_uri': instance.auth_uri,
      'token_uri': instance.token_uri,
      'auth_provider_x509_cert_url': instance.auth_provider_x509_cert_url,
    };
