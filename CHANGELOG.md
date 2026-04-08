# CHANGELOG

## 2.1.2

* **DISCONTINUED**: This package has been rebranded to [firebase_cloud_messaging_dart](https://pub.dev/packages/firebase_cloud_messaging_dart).
* Please migrate to the new package to receive future updates and Dart 3 modernizations.

## 2.1.1

This release elevates the package to a production-hardened server-side SDK by introducing native ambient credentials and dedicated topic management.

* **Feat (Auth)**: Introduced `FirebaseCloudMessagingServer.applicationDefault({ required String projectId })`. Supports Google Application Default Credentials (ADC) for seamless authentication in Cloud Run, App Engine, and Firebase Functions.
* **Feat (Topic Management)**: Added `subscribeTokensToTopic()` and `unsubscribeTokensFromTopic()`. These utilize the Firebase Instance ID API for efficient batch management (up to 1,000 tokens per request).
* **Refactor (Architecture)**: Introduced `FcmTopicManagement` internal class to centralize topic lifecycle logic.
* **Refactor (Breaking)**: Migrated project-wide filename convention to standard Dart snake_case (e.g., `android_config.dart`). All internal imports and public exports have been updated.
* **Hardening**: Consolidated network logic into a shared, reusable `http.Client` to prevent socket leaks.
* **Typing**: Added missing priority and visibility fields to platform-specific configs.
