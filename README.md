Send messages with Firebase Cloud Messaging from your dart backend!

Created using the HTTPv1 API of Firebase Cloud Messaging - you can find more on their [Firebase Cloud Messaging API Docs](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages).

Not affiliated in any way with the official Firebase team or Google. We just trying to help flutter & dart developers to send messages without using any external server.

## Developer Contact Details
- [Instagram](https://www.instagram.com/ottoman_coder/​)
- [Telegram](https://t.me/ottomancoder​)
- [Skype ID](https://join.skype.com/invite/Udbe33x6J98H)
- [Facebook Page](https://web.facebook.com/ottomancoder/)
- [Youtube Channel](https://www.youtube.com/c/OttomanCoder/videos)

## Usage

Settings > Service Accounts > Generate new key > Copy important informations directly from the created file or load it with FirebaseCloudMessagingServer( Your Service Account Content )

A simple usage example:

```dart
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';

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
      validateOnly: false,
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

```

## Features and bugs

Please file feature requests and bugs at the [Issue Tracker](https://github.com/OttomanDeveloper/firebase_cloud_messaging_flutter/issues).