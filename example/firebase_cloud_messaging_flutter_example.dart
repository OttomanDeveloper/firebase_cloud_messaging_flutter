import 'dart:io';
import 'dart:convert';
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';

/// Example file demonstrating the firebase_cloud_messaging_flutter v2.0.0 API.
///
/// To run this example, replace the placeholder values with your actual
/// Firebase service account credentials and device tokens.
///
/// Obtain service account credentials from:
///   Firebase Console → Settings → Service Accounts → Generate new private key
void main() async {
  // 1. Initialize the Server
  // Using explicit service account map parsing:
  final credentials = jsonDecode(
    File('service_account.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  var server = FirebaseCloudMessagingServer(
    credentials,
    logger: (level, message, {error, stackTrace}) {
      print('[FCM ${level.name.toUpperCase()}] $message');
      if (error != null) print('  Error: $error');
    },
  );

  // Alternatively, using Application Default Credentials (ADC)
  // ideal for Google Cloud Run / Firebase Functions deployment:
  /*
  server = FirebaseCloudMessagingServer.applicationDefault(
    projectId: 'my-project-id',
    logger: (level, message, {error, stackTrace}) {
      print('[FCM ${level.name.toUpperCase()}] $message');
      if (error != null) print('  Error: $error');
    },
  );
  */

  // --------------------------------------------------------------------------
  // 2. Send to a single device token
  // --------------------------------------------------------------------------
  const deviceToken = 'REPLACE_WITH_YOUR_DEVICE_TOKEN';

  final result = await server.send(
    FirebaseSend(
      message: FirebaseMessage(
        token: deviceToken,
        notification: const FirebaseNotification(
          title: 'Hello from v2.0.0 🚀',
          body: 'The package has been completely upgraded!',
          image: 'https://example.com/banner.png',
        ),
        android: FirebaseAndroidConfig(
          ttl: '86400s', // 24 hours
          priority: AndroidMessagePriority.high,
          directBootOk: false,
          notification: const FirebaseAndroidNotification(
            icon: 'ic_notification',
            color: '#FF6D00',
            channelID: 'default_channel',
            notificationPriority: NotificationPriority.priorityHigh,
            proxy: AndroidNotificationProxy.allow,
          ),
        ),
        apns: FirebaseApnsConfig(
          headers: const {'apns-priority': '10'},
          notification: const FirebaseApnsNotification(
            title: 'Hello!',
            body: 'iOS-specific notification body.',
            badge: 1,
            sound: 'default',
          ),
          fcmOptions: const ApnsFcmOptions(
            analyticsLabel: 'v2_launch',
            image: 'https://example.com/ios-banner.png',
          ),
        ),
        webpush: FirebaseWebpushConfig(
          notification: const FirebaseWebpushNotification(
            title: 'Hello!',
            body: 'Web-specific notification body.',
            icon: 'https://example.com/icon.png',
            requireInteraction: true,
            actions: [
              WebpushAction(action: 'open_app', title: 'Open'),
              WebpushAction(action: 'dismiss', title: 'Dismiss'),
            ],
          ),
          fcmOptions: const WebpushFcmOptions(
            link: 'https://example.com',
            analyticsLabel: 'web_push',
          ),
        ),
        fcmOptions: const FirebaseFcmOptions(
          analyticsLabel: 'example',
          image: 'https://example.com/cross-platform.png',
        ),
      ),
    ),
  );

  print('Single send result: $result');
  if (!result.successful) {
    print('Error code: ${result.fcmError?.errorCode}');
    print('Is retryable: ${result.fcmError?.isRetryable}');
  }

  // --------------------------------------------------------------------------
  // 4. Send to multiple tokens in parallel (new in v2.0.0)
  // --------------------------------------------------------------------------
  final tokens = ['token_a', 'token_b', 'token_c'];

  final batchResult = await server.sendToMultiple(
    tokens: tokens,
    messageTemplate: const FirebaseMessage(
      notification: FirebaseNotification(
        title: 'Batch notification',
        body: 'Sent to all users in parallel.',
      ),
    ),
  );

  print('Batch result: $batchResult');
  print('  Succeeded: ${batchResult.successCount}');
  print('  Failed:    ${batchResult.failureCount}');

  // Remove stale tokens from your database
  for (final r in batchResult.failedResults) {
    if (r.serverResult.fcmError?.errorCode == FcmErrorCode.unregistered) {
      print('  Stale token (remove from DB): ${r.token}');
    }
  }

  // ---------------------------------------------------------------------------
  // 3. Topic Subscriptions & Topic Messaging
  // ---------------------------------------------------------------------------

  // A. Subscribe tokens to a topic (Up to 1000 tokens per request)
  final topicResult = await server.subscribeTokensToTopic(
    topic: 'sports',
    tokens: ['fake-token-4', 'fake-token-5'],
  );
  print('Topic subscription successful: ${topicResult.successCount}');

  // B. Send message to the topic
  final topicSendResult = await server.sendToTopic(
    'sports',
    const FirebaseMessage(
      notification: FirebaseNotification(
        title: 'Goal!',
        body: 'The local team scored.',
      ),
    ),
  );
  print('Topic send successful: ${topicSendResult.successful}');

  // --------------------------------------------------------------------------
  // 6. Send to a condition (new convenience method in v2.0.0)
  // --------------------------------------------------------------------------
  await server.sendToCondition(
    "'sports' in topics || 'news' in topics",
    const FirebaseMessage(
      notification: FirebaseNotification(
        title: 'Sports & News Alert',
        body: 'Something for both audiences.',
      ),
    ),
  );

  // --------------------------------------------------------------------------
  // 7. Validate a message without sending it (new in v2.0.0)
  // --------------------------------------------------------------------------
  final validationResult = await server.validateMessage(
    FirebaseSend(
      message: const FirebaseMessage(
        token: 'some-token',
        notification: FirebaseNotification(title: 'Test'),
      ),
    ),
  );
  print('Validation passed: ${validationResult.successful}');

  // --------------------------------------------------------------------------
  // 8. Always dispose the server when done (new in v2.0.0)
  // --------------------------------------------------------------------------
  server.dispose();
}
