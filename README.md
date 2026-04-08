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

### 2. Initializing the Service Account Credentials (Important)

Your Firebase project requires authentication to send messages. For server-to-server communication (or Dart backends), this is done using a **Service Account JSON file**.

**How to get it:**

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Select your project.
3. Click the gear icon (Project Settings) > **Service accounts**.
4. Click **Generate new private key**.
5. This downloads a `service_account.json` file.

**Where to put it:**
Place this file in a secure location in your Dart/Flutter backend application. (e.g., the root of your server project).

> [!WARNING]
> **NEVER commit this file to public version control (like GitHub).** It grants full administrative access to your Firebase project. Always add `service_account.json` to your `.gitignore` file. If running in a managed environment, consider using Application Default Credentials (ADC) or Secret Managers instead (see the ADC section below).

### 3. Import

```dart
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';
```

---

## Usage

### Basic — send to one device

```dart
import 'dart:io';
import 'dart:convert';
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';

void main() async {
  // Pass the contents of the downloaded JSON file to the constructor.
  // - Option A (Persistent auth): FirebaseCloudMessagingServer(credentials, cacheAuth: true) (Recommended)
  // - Option B (One-time auth): FirebaseCloudMessagingServer(credentials, cacheAuth: false)
  final credentials = jsonDecode(
    File('service_account.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  final server = FirebaseCloudMessagingServer(credentials);

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

### Application Default Credentials (ADC)

If your Dart backend executes inside a Google serverless environment (e.g. Cloud Run, App Engine, or Firebase Cloud Functions), you can securely bypass tracking raw JSON files by adopting Application Default Credentials.

```dart
final server = FirebaseCloudMessagingServer.applicationDefault(
  projectId: 'my-project-id', 
);
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

### Running Tests

This package includes a comprehensive test suite to ensure message serialization and error handling are correct.

### Using Dart (Pure Dart projects)

```bash
dart pub get
dart test
```

### Using Flutter (Flutter projects or misconfigured environments)

If your environment's `dart test` complains about missing snapshots (common in Flutter-managed SDKs), use:

```bash
flutter test
```

---

## Sending to a Topic or Condition

You can route messages via FCM Publisher Topics or via Logical Conditions.

```dart
final result = await server.sendToTopic(
  'breaking-news', // Note: omit the `/topics/` prefix here
  FirebaseMessage(
    notification: FirebaseNotification(title: 'News Alert'),
  ),
);
```

### Managing Topic Subscriptions natively

This package includes a wrapper for the Firebase Instance ID API, allowing you to explicitly subscribe or unsubscribe device tokens to a topic sequentially.

```dart
final bulkSubResult = await server.subscribeTokensToTopic(
  topic: 'breaking-news',
  tokens: ['token1', 'token2', 'token3'], // Up to 1000 tokens
);

if (!bulkSubResult.allSuccessful) {
  print('Some tokens failed: ${bulkSubResult.failedResults}');
}

// To unsubscribe:
// await server.unsubscribeTokensFromTopic(topic: 'breaking-news', tokens: ['token1']);
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

## Contributing

We welcome contributions of all kinds! Whether you're fixing bugs, improving documentation, or adding new FCM features, please read our [Contributing Guide](CONTRIBUTING.md) to get started.

---

## Developer Contact
- [GitHub](https://github.com/OttomanDeveloper/firebase_cloud_messaging_flutter)
- [Issue Tracker](https://github.com/OttomanDeveloper/firebase_cloud_messaging_flutter/issues)