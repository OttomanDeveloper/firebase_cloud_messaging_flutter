## 2.0.0

### Breaking Changes
- `AndroidMessagePriority.normal` and `.high` now serialize to `"NORMAL"` and
  `"HIGH"` respectively (correct FCM API values). Previously they serialised as
  `"normal"` and `"high"`, causing FCM to reject the priority silently.
  **Action required:** regenerate `.g.dart` files with `build_runner`.
- `FirebaseWebpushConfig.notification` changed from `Map<String, dynamic>?` to
  the new typed `FirebaseWebpushNotification?` class.
- `FirebaseWebpushConfig.webPushFcmOptions` renamed to `fcmOptions` and is now
  typed as `WebpushFcmOptions?` instead of `Map<String, dynamic>?`.
- `ServerResult.messageSent` is now nullable (`FirebaseMessage?`).
- `json_serializable` moved from `dependencies` to `dev_dependencies`.

### New Features
- **`sendToMultiple()`** — sends one notification to many device tokens in
  parallel using `Future.wait`. Returns a `BatchResult` with per-token
  `TokenResult` entries.
- **`sendToTopic()`** — convenience method for topic-targeted messages.
- **`sendToCondition()`** — convenience method for condition-targeted messages.
- **`validateMessage()`** — dry-run a message without delivering it.
- **`FcmLogger`** — optional structured logging callback. Replaces commented
  `print()` calls with a proper opt-in logging interface.
- **`FcmRetryConfig`** — configures exponential back-off retries for
  `QUOTA_EXCEEDED` and `UNAVAILABLE` FCM errors.
- **`FirebaseCloudMessagingServer.fromJsonString()`** — named constructor for
  loading credentials from a raw JSON string.
- **`FirebaseCloudMessagingServer.fromServiceAccountFile()`** — named constructor
  for loading credentials from a `dart:io` `File`.
- **`dispose()`** — closes the shared HTTP client cleanly.
- **`FcmError`** + **`FcmErrorCode`** — typed FCM error extracted from failed
  responses. Use `isRetryable` to decide whether to back off.
- **`BatchResult`** / **`TokenResult`** — aggregated result from `sendToMultiple`.

### API Completeness
- `FirebaseApnsConfig` — added typed `notification` (`FirebaseApnsNotification`)
  and `fcmOptions` (`ApnsFcmOptions`). Raw `payload` map preserved for
  advanced APS dictionary use.
- New `apns.notification.dart` — `FirebaseApnsNotification`, `ApnsAlert`, `ApnsFcmOptions`.
- `FirebaseWebpushConfig` — replaced raw `Map` fields with typed
  `FirebaseWebpushNotification` and `WebpushFcmOptions`.
- New `webpush.notification.dart` — `FirebaseWebpushNotification`, `WebpushAction`, `WebpushFcmOptions`.
- `FirebaseFcmOptions` — added missing `image` field.
- `FirebaseAndroidConfig` — added `directBootOk` (`direct_boot_ok`) field.
- `FirebaseAndroidNotification` — added `proxy` field with `AndroidNotificationProxy` enum.

### Bug Fixes
- Fixed HTTP client leak: a single `http.Client` is now reused across all
  send calls and closed via `dispose()`. Previously a new client was created
  (and leaked) on every `send()` invocation.
- Fixed `projectID` being re-parsed from JSON on every request; now cached at
  construction time.

### Quality
- Added `copyWith()` to `FirebaseMessage`, `FirebaseSend`, and `ServerResult`.
- Added `ServerResult.errorBody` (raw response body on failure) and
  `ServerResult.fcmError` (typed error).
- `FirebaseSend` now asserts that `message` is non-null at construction time.
- Added full unit test suite in `test/`.
- Updated all dev dependencies to latest versions.
- Updated minimum SDK to `>=2.17.0`.

---

## 1.0.6

- Updated dependencies
- Thanks to [@dsyrstad](https://github.com/dsyrstad)
- Made fixes to .gitignore and removed pubspec.lock to make it conform to a standard Dart package project.
- Upgraded to support Dart 3.0+.
- Fixed commenting — replacing /// with // where appropriate.
- Support Webpush fcm_options and support proper notification object.

## 1.0.5

- Improved code structure and quality

## 1.0.4

- Updated dependencies
- Improved code structure and quality

## 1.0.3

- Improved code structure and quality

## 1.0.2

- Updated Dependencies

## 1.0.1

- Improved Example and Document File

## 1.0.0

- Initial version, minor things missing
