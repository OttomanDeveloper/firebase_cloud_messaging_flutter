/// Firebase Cloud Messaging for Dart & Flutter — Server-side SDK
///
/// Sends FCM messages directly via the HTTP v1 REST API without requiring an
/// external server. Supports Android, iOS (APNs), and Web (WebPush) targets.
///
/// ## Getting started
/// ```dart
/// import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';
/// ```
///
/// See [FirebaseCloudMessagingServer] for the primary entry point.
library firebase_cloud_messaging_flutter;

// ---------------------------------------------------------------------------
// Server entry point & result types
// ---------------------------------------------------------------------------
export 'src/firebase.cloud.messaging.server.dart';
export 'src/logic/batch.result.dart';
export 'src/logic/topic.management.result.dart';

// ---------------------------------------------------------------------------
// Logger
// ---------------------------------------------------------------------------
export 'src/fcm.logger.dart';

// ---------------------------------------------------------------------------
// Core message models
// ---------------------------------------------------------------------------
export 'src/logic/fcm.options.dart';
export 'src/logic/firebase.service.model.dart';
export 'src/logic/message.dart';
export 'src/logic/notification.dart';
export 'src/logic/send.dart';

// ---------------------------------------------------------------------------
// Android
// ---------------------------------------------------------------------------
export 'src/logic/android.config.dart';
export 'src/logic/android.notification.dart';

// ---------------------------------------------------------------------------
// Apple (APNs)
// ---------------------------------------------------------------------------
export 'src/logic/apns.config.dart';
export 'src/logic/apns.notification.dart';

// ---------------------------------------------------------------------------
// Web Push
// ---------------------------------------------------------------------------
export 'src/logic/webpush.config.dart';
export 'src/logic/webpush.notification.dart';

// ---------------------------------------------------------------------------
// Error handling & retry
// ---------------------------------------------------------------------------
export 'src/logic/fcm.error.dart';
export 'src/logic/fcm.retry.dart';
