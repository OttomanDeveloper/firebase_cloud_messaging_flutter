import 'package:firebase_cloud_messaging_backend/firebase_cloud_messaging_backend.dart';

void main() async {
  /// My Service Account Json File Content
  final serviceAccountFileContent = <String, String>{
    'type': '',
    'project_id': '',
    'private_key_id': '',
    'private_key': '',
    'client_email': '',
    'client_id': '',
    'auth_uri': '',
    'token_uri': '',
    'auth_provider_x509_cert_url': '',
    'client_x509_cert_url': ''
  };

  /// Add Your Service Account File Content as Map
  var server = FirebaseCloudMessagingServer(
    serviceAccountFileContent,
  );

  /// Get Firebase  Messagin Token [Optional, If you want to send message to specific user]
  /// Don't pass token if you want to send message to all registered users
  // String? token = await FirebaseMessaging.instance.getToken();

  /// Send a Message
  var result = await server.send(
    FirebaseSend(
      validate_only: false,
      message: FirebaseMessage(
        notification: FirebaseNotification(
          title: 'Package by Ottoman',
          body: 'Ottoman added something new! 🔥',
        ),
        android: FirebaseAndroidConfig(
          ttl: '3s',

          /// Add Delay in String. If you want to add 1 minute delat then add it like "60s"
          notification: FirebaseAndroidNotification(
            icon: 'ic_notification',
            color: '#009999',
          ),
        ),
        // token:
        //     token, // only required If you want to send message to specific user.
      ),
    ),
  );

  /// Print Request response
  print(result.toString());
}
