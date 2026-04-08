# firebase_cloud_messaging_flutter (Discontinued)

> [!CAUTION]
> **This package has been renamed!**  
> Please use [firebase_cloud_messaging_dart](https://pub.dev/packages/firebase_cloud_messaging_dart) instead.

This package is no longer maintained. We have rebranded to `firebase_cloud_messaging_dart` to better reflect support for pure Dart environments (Serverpod, CLI, etc.) while remaining fully compatible with Flutter.

---

## 🚀 Key Features (Archived)

* **Zero-Dependency on Firebase SDK**: Works in pure Dart environments (backends, CLI, etc.) as well as Flutter.
* **Application Default Credentials (ADC)**: Native support for ambient identity on Google Cloud (Cloud Run, Functions, etc.).
* **Topic Management**: Natively subscribe or unsubscribe device tokens to topics (Instance ID API).
* **Structured Error Handling**: Deep visibility into FCM errors (`UNREGISTERED`, `QUOTA_EXCEEDED`, etc.) with typed objects.
* **Automatic Retries**: Intelligent exponential back-off for transient Google API errors.
