## 2.1.0

This release elevates the package to a production-hardened server-side SDK by introducing native ambient credentials and dedicated topic management.

* **Feat (Auth)**: Introduced `FirebaseCloudMessagingServer.applicationDefault({ required String projectId })`. Supports Google Application Default Credentials (ADC) for seamless authentication in Cloud Run, App Engine, and Firebase Functions.
* **Feat (Topic Management)**: Added `subscribeTokensToTopic()` and `unsubscribeTokensFromTopic()`. These utilize the Firebase Instance ID API for efficient batch management (up to 1,000 tokens per request).
* **Refactor (Architecture)**: Introduced `FcmTopicManagement` internal class to centralize topic lifecycle logic.
* **Refactor (Breaking)**: Migrated project-wide filename convention to standard Dart snake_case (e.g., `android_config.dart`). All internal imports and public exports have been updated.
* **Hardening**: Consolidated network logic into a shared, reusable `http.Client` to prevent socket leaks.
* **Typing**: Added missing priority and visibility fields to platform-specific configs.


## 2.0.0

### Breaking Changes

* `AndroidMessagePriority.normal` and `.high` now serialize to `"NORMAL"` and `"HIGH"` respectively.
* `FirebaseWebpushConfig.notification` changed to typed `FirebaseWebpushNotification`.
* `FirebaseWebpushConfig.webPushFcmOptions` renamed to `fcmOptions`.
* `ServerResult.messageSent` is now nullable.
* `json_serializable` moved to `dev_dependencies`.

### New Features

* **`sendToMultiple()`** — sends to many tokens in parallel.
* **`sendToTopic()`** — targeted topic messages.
* **`sendToCondition()`** — targeted condition messages.
* **`validateMessage()`** — dry-run support.
* **`onRegistrationChange`** — registration status callback.
* **`FcmLogger`** — structured logging.
* **`FcmRetryConfig`** — exponential back-off retries.
* **`FirebaseCloudMessagingServer.fromServiceAccountJson()`** — load from JSON string.
* **`FirebaseCloudMessagingServer.fromServiceAccountFile()`** — load from File.
* **`dispose()`** — clean resource cleanup.
* **`FcmError`** + **`FcmErrorCode`** — typed FCM error extracted from failed requests.
  responses. Use `isRetryable` to decide whether to back off.
* **`BatchResult`** / **`TokenResult`** — aggregated result from `sendToMultiple`.

### API Completeness

* `FirebaseApnsConfig` — added typed `notification` (`FirebaseApnsNotification`)
  and `fcmOptions` (`ApnsFcmOptions`). Raw `payload` map preserved for
  advanced APS dictionary use.
* New `apns.notification.dart` — `FirebaseApnsNotification`, `ApnsAlert`, `ApnsFcmOptions`.
* `FirebaseWebpushConfig` — replaced raw `Map` fields with typed
  `FirebaseWebpushNotification` and `WebpushFcmOptions`.
* New `webpush.notification.dart` — `FirebaseWebpushNotification`, `WebpushAction`, `WebpushFcmOptions`.
* `FirebaseFcmOptions` — added missing `image` field.
* `FirebaseAndroidConfig` — added `directBootOk` (`direct_boot_ok`) field.
* `FirebaseAndroidNotification` — added `proxy` field with `AndroidNotificationProxy` enum.

### Bug Fixes

* Fixed HTTP client leak: a single `http.Client` is now reused across all
  send calls and closed via `dispose()`. Previously a new client was created
  (and leaked) on every `send()` invocation.
* Fixed `projectID` being re-parsed from JSON on every request; now cached at
  construction time.

### Quality

*   Added `copyWith()` to `FirebaseMessage`, `FirebaseSend`, and `ServerResult`.
*   Added `ServerResult.errorBody` (raw response body on failure) and
    `ServerResult.fcmError` (typed error).
*   `FirebaseSend` now asserts that `message` is non-null at construction time.
*   Added full unit test suite in `test/`.
*   Updated all dev dependencies to latest versions.
*   Updated minimum SDK to `>=2.17.0`.

---

## 1.0.6

* Updated dependencies
* Thanks to [@dsyrstad](https://github.com/dsyrstad)
* Made fixes to .gitignore and removed pubspec.lock to make it conform to a standard Dart package project.
* Upgraded to support Dart 3.0+.
* Fixed commenting — replacing /// with // where appropriate.
* Support Webpush fcm_options and support proper notification object.

## 1.0.5

* Improved code structure and quality

## 1.0.4

* Updated dependencies
* Improved code structure and quality

## 1.0.3

* Improved code structure and quality

## 1.0.2

* Updated Dependencies

## 1.0.1

* Improved Example and Document File

## 1.0.0

* Initial version, minor things missing
