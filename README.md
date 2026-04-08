# firebase_cloud_messaging_dart

[![pub package](https://img.shields.io/pub/v/firebase_cloud_messaging_dart.svg)](https://pub.dev/packages/firebase_cloud_messaging_dart)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> [!TIP]
> **Found an issue?** We strive for 100% type safety and reliability. If you encounter any bugs or have feature requests, please [open an issue on GitHub](https://github.com/OttomanDeveloper/firebase_cloud_messaging_dart/issues).

Send Firebase Cloud Messages (FCM) and manage topics directly from your **Dart or Flutter** application. This package provides a pure-Dart, type-safe wrapper around the [FCM HTTP v1 REST API](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages), removing the need for an intermediate server or the complex Firebase Admin SDK in many scenarios.

---

## 🚀 Key Features

* Zero-Dependency on Firebase SDK: Works in pure Dart environments (backends, CLI, etc.) as well as Flutter.
* Enterprise-Grade Hardening: Built with strict analysis rules (`avoid_dynamic_calls`, `strict-inference`) and 100% explicit typing.
* Dart 3 Modernized: Utilizes `sealed` classes, Records, and Pattern matching for high-performance and exhaustive logic.
* Backward Compatible: Supports **Dart 3.0.0** and above for maximum reach across the Flutter and Dart ecosystem.
* Application Default Credentials (ADC)
* Topic Management: Natively subscribe or unsubscribe device tokens to topics (Instance ID API).
* Parallel Delivery: Built-in support for sending to multiple tokens efficiently with Record-based results.
* Structured Error Handling: Deep visibility into FCM errors (`UNREGISTERED`, `QUOTA_EXCEEDED`, etc.) with typed objects.
* Automatic Retries: Intelligent exponential back-off for transient Google API errors.
* Type-Safe Platforms: Dedicated, typed configurations for Android, APNs (iOS/macOS), and Web Push.

---

## 📦 Getting Started

### 1. Add dependency

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  firebase_cloud_messaging_dart: ^3.0.0
```

### 2. Authentication Setup

You have two primary ways to authenticate with Google:

#### Option A: Service Account JSON (Standard)

1. Download your `service-account.json` from **Firebase Console → Project Settings → Service accounts**.
2. Store it in your project root (e.g., `service-account.json`).
3. **Important**: Add `service-account.json` to your `.gitignore` to prevent leaking credentials.

> [!CAUTION]
> **NEVER** include your `service-account.json` in your source code or repository. It grants full administrative access to your Firebase project.

#### Option B: Application Default Credentials (ADC)

If running on **Google Cloud Run, App Engine, or Firebase Functions**, you don't need a JSON file. The SDK will automatically detect the service identity.

---

## 🛠 Usage

### Initialization

```dart
import 'package:firebase_cloud_messaging_dart/firebase_cloud_messaging_dart.dart';

// Option 1: Via Service Account File (Easiest for local/server)
final server = FirebaseCloudMessagingServer.fromServiceAccountFile('service-account.json');

// Option 2: Via Service Account JSON Map
// final server = FirebaseCloudMessagingServer(serviceAccountMap);

// Option 3: Via ADC (Recommended for Google Cloud/Firebase Functions)
final server = FirebaseCloudMessagingServer.applicationDefault(projectId: 'my-project-id');
```

### Sending to a Single Device

```dart
final result = await server.send(
  FirebaseSend(
    message: FirebaseMessage(
      token: 'device-token',
      notification: FirebaseNotification(
        title: 'Project Update',
        body: 'Version 3.0.0 is now Pure Dart!',
      ),
    ),
  ),
);

  // Dart 3 Exhaustive Pattern Matching for handling send outcomes
  switch (result) {
    case ServerSuccess(:final messageSent):
      print('✅ Message sent successfully! ID: ${messageSent.name}');
    case ServerFailure(:final fcmError):
      print('❌ FCM Error: ${fcmError?.errorCode}');
      print('   Summary: ${fcmError?.message}');
      print('   Is Retryable: ${fcmError?.isRetryable}');
  }
```

### Topic Management

You can subscribe users to topics and send messages to them without managing tokens manually.

```dart
// 1. Subscribe tokens to a topic
final subResult = await server.subscribeTokensToTopic(
  topic: 'news_alerts',
  tokens: ['token1', 'token2', 'token3'], // Up to 1,000 tokens
);

// 2. Send message to everyone on that topic
final topicResult = await server.sendToTopic(
  'news_alerts',
  FirebaseMessage(
    notification: FirebaseNotification(title: 'Breaking News!'),
  ),
);
```

### Sending to Multiple Tokens (Batch)

The `sendToMultiple` method fans out messages in parallel and aggregates the results.

```dart
final batch = await server.sendToMultiple(
  tokens: ['token_a', 'token_b', 'token_c'],
  messageTemplate: FirebaseMessage(
    notification: FirebaseNotification(title: 'Hello!'),
  ),
);

print('Success: ${batch.successCount} / ${batch.results.length}');

// Handle stale tokens automatically
for (final res in batch.failedResults) {
  if (res.serverResult.fcmError?.errorCode == FcmErrorCode.unregistered) {
    // Clear token from your database
    await myDatabase.removeToken(res.token);
  }
}
```

---

## 📱 Platform Specifics

### Android

Supports `direct_boot_ok`, `priority`, `ttl`, and detailed `AndroidNotification` options (icons, colors, sounds, channel IDs).

### APNs (iOS/macOS)

Typed `FirebaseApnsNotification` supports `badge`, `category`, `thread_id`, and `sound`. Custom data can still be passed via the `payload` map.

### Web Push

Supports `requireInteraction`, `actions` (buttons), and `WebpushFcmOptions` (including browser click-through links).

---

## 🛡 Advanced Configuration

### Logging

Integrate with your own logging framework by providing a callback:

```dart
final server = FirebaseCloudMessagingServer(
  credentials,
  logger: (level, message, {error, stackTrace}) {
    print('[FCM ${level.name}] $message');
  },
);
```

### Automatic Retries

Transient errors like `UNAVAILABLE` or `QUOTA_EXCEEDED` can be handled automatically:

```dart
final server = FirebaseCloudMessagingServer(
  credentials,
  retryConfig: FcmRetryConfig(
    maxRetries: 3,
    initialDelay: Duration(seconds: 1),
    maxDelay: Duration(seconds: 30),
  ),
);
```

---

## 🧹 Resource Management

Always dispose of the server instance when you are done to close the underlying HTTP client and prevent memory leaks.

```dart
server.dispose();
```

---

## 🤝 Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue. If you'd like to contribute code, please check out our [Contributing Guide](CONTRIBUTING.md).

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
