# firebase_cloud_messaging_flutter

Send Firebase Cloud Messages directly from your **Dart or Flutter** application — no external server required.

Built on the [FCM HTTP v1 REST API](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages). Supports Android, iOS (APNs), and Web Push targets.

> Not affiliated with Firebase or Google. This is a community package.

---

## Features

| Feature | Description |
|---------|-------------|
| `send()` | Send a message to a single device token |
| `sendToMultiple()` | Fan-out to many tokens in **parallel** |
| `sendToTopic()` | Send to an FCM topic |
| `sendToCondition()` | Send to a boolean topic condition |
| `validateMessage()` | Dry-run a message without delivering it |
| `FcmLogger` | Optional structured logging hook |
| `FcmRetryConfig` | Exponential back-off for retryable errors |
| `FcmError` | Typed error codes (`UNREGISTERED`, `QUOTA_EXCEEDED`, …) |
| Typed APNs config | `FirebaseApnsNotification`, `ApnsAlert`, `ApnsFcmOptions` |
| Typed Web Push config | `FirebaseWebpushNotification`, `WebpushFcmOptions`, `WebpushAction` |

---

## Getting started

### 1. Add to `pubspec.yaml`

```yaml
dependencies:
  firebase_cloud_messaging_flutter: ^2.0.0
```

### 2. Get service account credentials

In the Firebase Console: **Settings → Service Accounts → Generate new private key**.  
Download the JSON file and keep it safe — it grants full project access.

### 3. Import

```dart
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';
```

---

## Usage

### Basic — send to one device

```dart
import 'dart:io';
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';

void main() async {
  // Load credentials from the service account JSON file.
  final server = FirebaseCloudMessagingServer.fromServiceAccountFile(
    File('service_account.json'),
  );

  final result = await server.send(
    FirebaseSend(
      message: FirebaseMessage(
        token: '<device-registration-token>',
        notification: const FirebaseNotification(
          title: 'Hello!',
          body: 'Message from Dart 🎯',
        ),
        android: FirebaseAndroidConfig(
          priority: AndroidMessagePriority.high,
          notification: const FirebaseAndroidNotification(
            channelID: 'default',
            color: '#FF6D00',
          ),
        ),
      ),
    ),
  );

  print(result.successful ? 'Sent ✓' : 'Error: ${result.fcmError}');
  server.dispose();
}
```

### Send to multiple tokens in parallel

```dart
final batch = await server.sendToMultiple(
  tokens: listOfDeviceTokens,
  messageTemplate: const FirebaseMessage(
    notification: FirebaseNotification(
      title: 'Update available',
      body: 'Version 2.0 is here!',
    ),
  ),
);

print('Success: ${batch.successCount} / ${batch.results.length}');

// Remove stale tokens
for (final r in batch.failedResults) {
  if (r.serverResult.fcmError?.errorCode == FcmErrorCode.unregistered) {
    await db.removeToken(r.token);
  }
}
```

### Send to a topic

```dart
await server.sendToTopic(
  'breaking-news',          // no "/topics/" prefix
  const FirebaseMessage(
    notification: FirebaseNotification(title: '🔥 Breaking News'),
  ),
);
```

### Send to a condition

```dart
await server.sendToCondition(
  "'sports' in topics || 'news' in topics",
  const FirebaseMessage(
    notification: FirebaseNotification(title: 'Alert for sports & news fans'),
  ),
);
```

### Validate without sending

```dart
final dryRun = await server.validateMessage(
  FirebaseSend(
    message: FirebaseMessage(
      token: someToken,
      notification: const FirebaseNotification(title: 'Test'),
    ),
  ),
);
print('Payload valid: ${dryRun.successful}');
```

### With logger and retry config

```dart
final server = FirebaseCloudMessagingServer(
  credentials,
  logger: (level, message, {error, stackTrace}) {
    print('[FCM ${level.name}] $message');
  },
  retryConfig: const FcmRetryConfig(
    maxRetries: 3,
    initialDelay: Duration(seconds: 1),
    maxDelay: Duration(seconds: 30),
  ),
);
```

### iOS (APNs) specific configuration

```dart
apns: FirebaseApnsConfig(
  headers: const {'apns-priority': '10'},
  notification: const FirebaseApnsNotification(
    title: 'Hello iOS',
    body: 'With album artwork thumbnail',
    badge: 1,
    sound: 'default',
    category: 'MESSAGE',
  ),
  fcmOptions: const ApnsFcmOptions(
    analyticsLabel: 'ios_campaign',
    image: 'https://example.com/thumbnail.jpg',
  ),
),
```

### Web Push specific configuration

```dart
webpush: FirebaseWebpushConfig(
  notification: const FirebaseWebpushNotification(
    title: 'Hello Web',
    body: 'With action buttons',
    requireInteraction: true,
    actions: [
      WebpushAction(action: 'open', title: 'Open app'),
      WebpushAction(action: 'dismiss', title: 'Dismiss'),
    ],
  ),
  fcmOptions: const WebpushFcmOptions(link: 'https://yourapp.com'),
),
```

---

## Handling errors

```dart
final result = await server.send(sendObject);

if (!result.successful) {
  final err = result.fcmError;
  switch (err?.errorCode) {
    case FcmErrorCode.unregistered:
      // Remove the token from your database.
      break;
    case FcmErrorCode.quotaExceeded:
      // Back off — the server will retry automatically if FcmRetryConfig is set.
      break;
    default:
      print('FCM error: $err');
  }
}
```

---

## Upgrading from v1.x

1. Run `dart pub upgrade` to get v2.0.0.
2. Run `dart run build_runner build --delete-conflicting-outputs` to regenerate `.g.dart` files.
3. Check uses of `FirebaseWebpushConfig` — `notification` and `webPushFcmOptions` are now typed.
4. If you relied on `AndroidMessagePriority` serializing to lowercase (`"normal"`/`"high"`),
   update your FCM server-side expectations — the correct values are `"NORMAL"`/`"HIGH"`.
5. Call `server.dispose()` when you are done with the server instance.

---

## Developer Contact
- [GitHub](https://github.com/OttomanDeveloper/firebase_cloud_messaging_flutter)
- [Issue Tracker](https://github.com/OttomanDeveloper/firebase_cloud_messaging_flutter/issues)