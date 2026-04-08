import 'dart:convert';
import 'dart:io';

import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';
import 'package:firebase_cloud_messaging_flutter/src/logic/fcm_topic_management.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

/// A server-side client for sending Firebase Cloud Messages via the
/// FCM HTTP v1 API directly from Dart or Flutter.
///
/// The default base endpoint used is [_fcmApiEndpoint].
///
/// ## Quick start
/// ```dart
/// import 'dart:convert';
/// import 'dart:io';
/// import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';
///
/// void main() async {
///   final credentials = jsonDecode(
///     File('service_account.json').readAsStringSync(),
///   ) as Map<String, dynamic>;
///
///   final server = FirebaseCloudMessagingServer(credentials);
///
///   final result = await server.send(
///     FirebaseSend(
///       message: FirebaseMessage(
///         token: '<device-token>',
///         notification: FirebaseNotification(
///           title: 'Hello!',
///           body: 'Message from the server.',
///         ),
///       ),
///     ),
///   );
///
///   print(result);
///   server.dispose(); // Always dispose when done.
/// }
/// ```
///
/// ## Authentication
/// [FirebaseCloudMessagingServer] authenticates with FCM using a
/// [Google Service Account](https://firebase.google.com/docs/admin/setup#initialize_the_sdk_in_non-google_environments).
/// Open **Firebase Console → Settings → Service Accounts → Generate new private key**
/// and pass the contents of the downloaded JSON file to this constructor.
///
/// ## Caching & disposal
/// By default ([cacheAuth] = `true`) the OAuth 2.0 access token is reused
/// until it expires (≈1 hour), then refreshed automatically. Call [dispose]
/// when you are done with the server to close the underlying HTTP client.
class FirebaseCloudMessagingServer {
  // ---------------------------------------------------------------------------
  // Constants
  // ---------------------------------------------------------------------------

  /// The base URL path for the FCM HTTP v1 API.
  static const String _fcmApiEndpoint =
      'https://fcm.googleapis.com/v1/projects';

  /// The endpoint for the IID batch registration API (Subscribe).
  // MOVED to FcmTopicManagement

  /// The endpoint for the IID batch registration API (Unsubscribe).
  // MOVED to FcmTopicManagement

  // ---------------------------------------------------------------------------
  // Constructor & fields
  // ---------------------------------------------------------------------------

  /// The service account credentials loaded from Firebase Console.
  ///
  /// This is the entire JSON map from the downloaded service-account file.
  /// If `null`, the server expects to authenticate using Google Application
  /// Default Credentials (ADC).
  final Map<String, dynamic>? firebaseServiceCredentials;

  /// When `true` (default), the OAuth access token is cached and reused until
  /// it expires. Set to `false` to force a fresh token on every request.
  final bool cacheAuth;

  /// Optional logger for diagnostic output.
  ///
  /// Defaults to [fcmSilentLogger] which discards all messages.
  /// Supply your own callback to integrate with your logging framework.
  final FcmLogger logger;

  /// Controls automatic retry for retryable FCM errors
  /// (`QUOTA_EXCEEDED` and `UNAVAILABLE`).
  ///
  /// Defaults to [FcmRetryConfig] (3 retries, exponential back-off).
  final FcmRetryConfig retryConfig;

  /// Optional callback triggered when a token registration becomes invalid.
  final FcmRegistrationCallback? onRegistrationChange;

  /// The FCM project ID extracted from [firebaseServiceCredentials].
  /// Cached at construction time to avoid repeated JSON parsing.
  late final String _projectId;

  /// The cached OAuth 2.0 access token.
  AccessCredentials? _accessCredentials;

  /// Shared HTTP client reused across all send operations.
  /// Closed by [dispose].
  final http.Client _httpClient;

  /// Prevents multiple simultaneous authentication refreshes when
  /// many requests are fired in parallel.
  Future<void>? _authFuture;

  // ---------------------------------------------------------------------------
  // Constructors
  // ---------------------------------------------------------------------------

  /// Creates a server instance from a pre-parsed service-account [Map].
  ///
  /// [firebaseServiceCredentials] — the full content of the Firebase service
  /// account JSON as a [Map<String, dynamic>].
  ///
  /// [cacheAuth] — whether to reuse the OAuth token until it expires.
  ///
  /// [logger] — optional logging callback (default: silent).
  ///
  /// [retryConfig] — retry behaviour for retryable FCM errors
  /// (default: 3 retries with exponential back-off).
  ///
  /// [projectId] — required ONLY if [firebaseServiceCredentials] is `null` (ADC mode).
  FirebaseCloudMessagingServer(
    this.firebaseServiceCredentials, {
    String? projectId,
    this.cacheAuth = true,
    this.logger = fcmSilentLogger,
    this.retryConfig = const FcmRetryConfig(),
    this.onRegistrationChange,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client() {
    if (firebaseServiceCredentials != null) {
      // Cache the projectId so we don't re-parse the entire JSON on every send.
      final model = FirebaseServiceModel.fromJson(firebaseServiceCredentials!);
      _projectId = model.projectID ?? '';
      assert(
        _projectId.isNotEmpty,
        'Service account JSON is missing the "project_id" field.',
      );
    } else {
      assert(
        projectId != null,
        'Project ID must be provided when using ADC mode.',
      );
      _projectId = projectId!;
    }
  }

  /// Creates a server instance that authenticates using Google Application
  /// Default Credentials (ADC).
  ///
  /// This is the recommended approach for serverless environments like
  /// Google Cloud Run, App Engine, or Firebase Cloud Functions, as it securely
  /// detects the ambient Google Cloud service account identity automatically.
  /// No static JSON file is required.
  ///
  /// Because ADC does not supply the `project_id` upfront, you must provide
  /// your Firebase [projectId] manually.
  factory FirebaseCloudMessagingServer.applicationDefault({
    required String projectId,
    bool cacheAuth = true,
    FcmLogger? logger,
    FcmRetryConfig retryConfig = const FcmRetryConfig(),
    FcmRegistrationCallback? onRegistrationChange,
    http.Client? httpClient,
  }) {
    return FirebaseCloudMessagingServer(
      null,
      projectId: projectId,
      cacheAuth: cacheAuth,
      logger: logger ?? fcmSilentLogger,
      retryConfig: retryConfig,
      onRegistrationChange: onRegistrationChange,
      httpClient: httpClient,
    );
  }

  /// Creates a server instance from a service-account JSON [String].
  ///
  /// This is a convenience for loading the file content directly.
  ///
  /// ```dart
  /// final json = await File('key.json').readAsString();
  /// final server = FirebaseCloudMessagingServer.fromServiceAccountJson(json);
  /// ```
  factory FirebaseCloudMessagingServer.fromServiceAccountJson(
    String jsonString, {
    bool cacheAuth = true,
    FcmLogger? logger,
    FcmRetryConfig retryConfig = const FcmRetryConfig(),
    FcmRegistrationCallback? onRegistrationChange,
    http.Client? httpClient,
  }) {
    final Map<String, dynamic> credentials =
        json.decode(jsonString) as Map<String, dynamic>;
    return FirebaseCloudMessagingServer(
      credentials,
      cacheAuth: cacheAuth,
      logger: logger ?? fcmSilentLogger,
      retryConfig: retryConfig,
      onRegistrationChange: onRegistrationChange,
      httpClient: httpClient,
    );
  }

  /// Creates a server instance by reading a service-account JSON file.
  ///
  /// The [serviceAccountFile] can be a [File] object or a [String] path.
  ///
  /// ```dart
  /// final server = FirebaseCloudMessagingServer.fromServiceAccountFile(
  ///   'service_account.json',
  /// );
  /// ```
  factory FirebaseCloudMessagingServer.fromServiceAccountFile(
    Object serviceAccountFile, {
    bool cacheAuth = true,
    FcmLogger? logger,
    FcmRetryConfig retryConfig = const FcmRetryConfig(),
    FcmRegistrationCallback? onRegistrationChange,
    http.Client? httpClient,
  }) {
    final file = serviceAccountFile is String
        ? File(serviceAccountFile)
        : serviceAccountFile as File;

    return FirebaseCloudMessagingServer.fromServiceAccountJson(
      file.readAsStringSync(),
      cacheAuth: cacheAuth,
      logger: logger ?? fcmSilentLogger,
      retryConfig: retryConfig,
      onRegistrationChange: onRegistrationChange,
      httpClient: httpClient,
    );
  }

  // ---------------------------------------------------------------------------
  // Public send API
  // ---------------------------------------------------------------------------

  /// Sends a single FCM message.
  ///
  /// Returns a [ServerResult] containing the delivery outcome.
  ///
  /// ```dart
  /// final result = await server.send(
  ///   FirebaseSend(
  ///     message: FirebaseMessage(
  ///       token: deviceToken,
  ///       notification: FirebaseNotification(title: 'Hi', body: 'Hello'),
  ///     ),
  ///   ),
  /// );
  /// if (!result.successful) print(result.fcmError);
  /// ```
  Future<ServerResult> send(FirebaseSend sendObject) => _send(sendObject);

  /// Sends the same notification to [tokens] in **parallel** and returns an
  /// aggregated [BatchResult].
  ///
  /// Internally this creates one [FirebaseSend] per token and fires all
  /// requests concurrently with [Future.wait]. Inspect [BatchResult.failedResults]
  /// to detect stale tokens (e.g., `FcmErrorCode.unregistered`).
  ///
  /// ```dart
  /// final batch = await server.sendToMultiple(
  ///   tokens: allDeviceTokens,
  ///   messageTemplate: FirebaseMessage(
  ///     notification: FirebaseNotification(title: 'Update!', body: 'New version.'),
  ///   ),
  /// );
  /// print('Success: ${batch.successCount} / ${batch.results.length}');
  /// ```
  Future<BatchResult> sendToMultiple({
    required List<String> tokens,
    required FirebaseMessage messageTemplate,
    bool validateOnly = false,
  }) async {
    assert(tokens.isNotEmpty, 'tokens list must not be empty');

    logger(
        FcmLogLevel.info, 'sendToMultiple: sending to ${tokens.length} tokens');

    // Fan out all requests in parallel for maximum throughput.
    final List<Future<TokenResult>> futures = tokens.map((token) async {
      final serverResult = await _send(
        FirebaseSend(
          validateOnly: validateOnly,
          message: messageTemplate.copyWith(token: token),
        ),
      );
      return TokenResult(token: token, serverResult: serverResult);
    }).toList();

    final List<TokenResult> results = await Future.wait(futures);
    final batch = BatchResult(results: results);

    logger(
      FcmLogLevel.info,
      'sendToMultiple: done — ${batch.successCount} succeeded, '
      '${batch.failureCount} failed',
    );
    return batch;
  }

  /// Convenience method to send a message to an FCM **topic**.
  ///
  /// Note: the `"/topics/"` prefix must NOT be included in [topic].
  ///
  /// ```dart
  /// await server.sendToTopic(
  ///   'breaking-news',
  ///   FirebaseMessage(notification: FirebaseNotification(title: '🔥 Breaking')),
  /// );
  /// ```
  Future<ServerResult> sendToTopic(
    String topic,
    FirebaseMessage message,
  ) {
    return _send(
      FirebaseSend(
        message: message.copyWith(
          topic: topic,
          token: null,
          condition: null,
        ),
      ),
    );
  }

  /// Convenience method to send a message to devices matching a **condition**.
  ///
  /// Condition syntax: `"'topic1' in topics && 'topic2' in topics"`.
  ///
  /// ```dart
  /// await server.sendToCondition(
  ///   "'sports' in topics || 'news' in topics",
  ///   FirebaseMessage(notification: FirebaseNotification(title: 'Alert')),
  /// );
  /// ```
  Future<ServerResult> sendToCondition(
    String condition,
    FirebaseMessage message,
  ) {
    return _send(
      FirebaseSend(
        message: message.copyWith(
          condition: condition,
          token: null,
          topic: null,
        ),
      ),
    );
  }

  /// Validates a message payload without actually delivering it.
  ///
  /// FCM processes the request and returns errors if the payload is invalid,
  /// but the message is never sent.
  ///
  /// ```dart
  /// final result = await server.validateMessage(
  ///   FirebaseSend(message: myMessage),
  /// );
  /// if (!result.successful) print('Payload error: ${result.fcmError}');
  /// ```
  Future<ServerResult> validateMessage(FirebaseSend sendObject) {
    return _send(sendObject.copyWith(validateOnly: true));
  }

  /// Sends multiple pre-built [FirebaseSend] objects **sequentially**.
  ///
  /// Prefer [sendToMultiple] for better throughput when sending the same
  /// message to many tokens. Use this method when each message is distinct.
  ///
  /// Returns a [List<ServerResult>] in the same order as [sendObjects].
  Future<List<ServerResult>> sendMessages(
    List<FirebaseSend> sendObjects,
  ) async {
    final List<ServerResult> results = [];
    for (final sendObject in sendObjects) {
      results.add(await _send(sendObject));
    }
    return results;
  }

  // ---------------------------------------------------------------------------
  // Authentication
  // ---------------------------------------------------------------------------

  /// Fetches a fresh OAuth 2.0 access token from Google and caches it.
  ///
  /// This is called automatically by [_send] — you do not need to call it
  /// directly unless you want to pre-warm the credentials.
  Future<AccessCredentials> performAuth() async {
    logger(FcmLogLevel.debug, 'Requesting new OAuth access token from Google');

    const List<String> scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    if (firebaseServiceCredentials != null) {
      final ServiceAccountCredentials accountCredentials =
          ServiceAccountCredentials.fromJson(firebaseServiceCredentials!);

      // Use the shared client for auth.
      _accessCredentials = await obtainAccessCredentialsViaServiceAccount(
        accountCredentials,
        scopes,
        _httpClient,
      );
    } else {
      // Application Default Credentials (ADC)
      // clientViaApplicationDefaultCredentials creates its own AuthClient
      // wrapping a default inner HTTP client, which we then close after grabbing
      // the token, avoiding resource leaks.
      final authClient =
          await clientViaApplicationDefaultCredentials(scopes: scopes);
      try {
        _accessCredentials = authClient.credentials;
      } finally {
        authClient.close();
      }
    }

    logger(
      FcmLogLevel.debug,
      'Access token obtained. Expires: ${_accessCredentials!.accessToken.expiry}',
    );

    return _accessCredentials!;
  }

  // ---------------------------------------------------------------------------
  // Core send implementation
  // ---------------------------------------------------------------------------

  /// Sends [sendObject] to FCM, handling auth refresh and retries.
  Future<ServerResult> _send(FirebaseSend sendObject) async {
    assert(
      sendObject.message != null,
      'FirebaseSend.message must not be null. Either provide a token, topic, or condition.',
    );

    // Ensure we have a valid, non-expired access token.
    await _ensureValidToken();

    return _sendWithRetry(sendObject, attempt: 0);
  }

  /// Performs the actual HTTP POST, retrying on retryable failures.
  Future<ServerResult> _sendWithRetry(
    FirebaseSend sendObject, {
    required int attempt,
  }) async {
    final url = Uri.parse(
      '$_fcmApiEndpoint/$_projectId/messages:send',
    );

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_accessCredentials!.accessToken.data}',
    };

    logger(
      FcmLogLevel.debug,
      'Sending FCM request (attempt ${attempt + 1})',
    );

    final http.Response response;
    try {
      response = await _httpClient.post(
        url,
        headers: headers,
        body: json.encode(sendObject.toJson()),
      );
    } catch (e, st) {
      logger(FcmLogLevel.error, 'HTTP request failed',
          error: e, stackTrace: st);
      rethrow;
    }

    final bool successful = response.statusCode == 200;

    // Parse the response body for the FCM message name or error details.
    Map<String, dynamic>? bodyMap;
    try {
      bodyMap = json.decode(response.body) as Map<String, dynamic>?;
    } catch (_) {
      // Body is not JSON — leave bodyMap null.
    }

    // Extract a typed FCM error when the request was not successful.
    FcmError? fcmError;
    if (!successful && bodyMap != null) {
      fcmError = FcmError.fromResponseBody(bodyMap);
    }

    // Build the result object before deciding whether to retry.
    final result = ServerResult(
      successful: successful,
      statusCode: response.statusCode,
      errorPhrase: response.reasonPhrase,
      errorBody: successful ? null : response.body,
      fcmError: fcmError,
      messageSent: successful && bodyMap != null
          ? FirebaseMessage.fromJson(bodyMap)
          : const FirebaseMessage(),
    );

    final targetToken = sendObject.message?.token;

    if (successful) {
      logger(FcmLogLevel.info, 'Message sent: ${result.messageSent?.name}');
      if (targetToken != null) {
        onRegistrationChange?.call(targetToken, FcmRegistrationStatus.active);
      }
      return result;
    }

    logger(
      FcmLogLevel.warning,
      'FCM request failed [${response.statusCode}]: '
      '${fcmError?.status ?? response.reasonPhrase}',
    );

    // Trigger registration callback if the token is unregistered.
    if (fcmError?.errorCode == FcmErrorCode.unregistered &&
        targetToken != null) {
      onRegistrationChange?.call(
          targetToken, FcmRegistrationStatus.unregistered);
    }

    // Retry if the error is transient and we have retries remaining.
    if (fcmError != null &&
        fcmError.isRetryable &&
        attempt < retryConfig.maxRetries) {
      final delay = retryConfig.delayForAttempt(attempt);
      logger(
        FcmLogLevel.warning,
        'Retrying in ${delay.inMilliseconds}ms '
        '(attempt ${attempt + 1}/${retryConfig.maxRetries})',
      );
      await Future.delayed(delay);
      // Refresh token before retry in case it expired during the wait.
      await _ensureValidToken();
      return _sendWithRetry(sendObject, attempt: attempt + 1);
    }

    return result;
  }

  // ---------------------------------------------------------------------------
  // Topic Management
  // ---------------------------------------------------------------------------

  /// Subscribes a list of registration [tokens] to an FCM [topic].
  ///
  /// This utilizes the Firebase Instance ID API `batchAdd` endpoint.
  /// You can subscribe up to 1,000 tokens in a single request.
  /// The [topic] should not include the `"/topics/"` prefix.
  Future<TopicManagementResult> subscribeTokensToTopic({
    required String topic,
    required List<String> tokens,
  }) async {
    return _modifyTopicSubscription(
      topic: topic,
      tokens: tokens,
      isSubscription: true,
    );
  }

  /// Unsubscribes a list of registration [tokens] from an FCM [topic].
  ///
  /// This utilizes the Firebase Instance ID API `batchRemove` endpoint.
  /// You can unsubscribe up to 1,000 tokens in a single request.
  /// The [topic] should not include the `"/topics/"` prefix.
  Future<TopicManagementResult> unsubscribeTokensFromTopic({
    required String topic,
    required List<String> tokens,
  }) async {
    return _modifyTopicSubscription(
      topic: topic,
      tokens: tokens,
      isSubscription: false,
    );
  }

  /// Internal driver for the Firebase Instance ID API since the `messages:send`
  /// endpoint only _sends_ to topics but doesn't _manage_ them.
  Future<TopicManagementResult> _modifyTopicSubscription({
    required String topic,
    required List<String> tokens,
    required bool isSubscription,
  }) async {
    assert(
      tokens.isNotEmpty && tokens.length <= 1000,
      'Topic management supports between 1 and 1000 tokens per request.',
    );
    assert(
      !topic.contains('/'),
      'Topic string should not contain the `/topics/` prefix — simply provide the name (e.g. "news").',
    );

    // Topic management uses the exact same OAuth 2.0 access token as message delivery.
    await _ensureValidToken();

    return FcmTopicManagement.performBatchOperation(
      topic: topic,
      tokens: tokens,
      accessToken: _accessCredentials!.accessToken.data,
      client: _httpClient,
      isSubscription: isSubscription,
      logger: logger,
    );
  }

  // ---------------------------------------------------------------------------
  // Token validation helper
  // ---------------------------------------------------------------------------

  /// Ensures [_accessCredentials] is populated and non-expired.
  Future<void> _ensureValidToken() async {
    final bool hasCredentials = _accessCredentials != null;
    final bool isExpired = hasCredentials &&
        DateTime.now().isAfter(_accessCredentials!.accessToken.expiry);
    final bool forceRefresh = !cacheAuth;

    if (!hasCredentials || isExpired || forceRefresh) {
      // If an auth request is already in progress, wait for it.
      if (_authFuture != null) {
        await _authFuture;
        return;
      }

      // Capture the future to prevent duplicate triggers.
      _authFuture = performAuth();
      try {
        await _authFuture;
      } finally {
        _authFuture = null;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Closes the underlying HTTP client and releases resources.
  ///
  /// Call this when the server is no longer needed (e.g., in `dispose()` of
  /// a widget or service locator cleanup). After calling [dispose], the server
  /// instance should not be used again.
  void dispose() {
    _httpClient.close();
    logger(FcmLogLevel.debug, 'FirebaseCloudMessagingServer disposed');
  }
}

// ---------------------------------------------------------------------------
// ServerResult
// ---------------------------------------------------------------------------

/// Holds the outcome of a single FCM send request.
///
/// Check [successful] first; if `false`, inspect [fcmError] for a typed error
/// or [errorBody] for the raw response body.
class ServerResult {
  /// Whether FCM accepted and will deliver the message.
  final bool successful;

  /// The HTTP status code returned by FCM (200 on success).
  final int statusCode;

  /// The [FirebaseMessage] identifier returned by FCM on success.
  ///
  /// Contains `null` values on failure — always check [successful] first.
  final FirebaseMessage? messageSent;

  /// The HTTP reason phrase (e.g., `"Bad Request"`).
  final String? errorPhrase;

  /// The raw response body on failure, for advanced debugging.
  ///
  /// `null` when [successful] is `true`.
  final String? errorBody;

  /// Structured FCM error extracted from [errorBody], when available.
  ///
  /// Use [FcmError.isRetryable] and [FcmError.errorCode] for programmatic
  /// error handling. `null` when [successful] is `true` or when the body
  /// could not be parsed.
  final FcmError? fcmError;

  const ServerResult({
    required this.successful,
    required this.statusCode,
    this.messageSent,
    this.errorPhrase,
    this.errorBody,
    this.fcmError,
  });

  /// Creates a copy with the specified fields replaced.
  ServerResult copyWith({
    bool? successful,
    int? statusCode,
    FirebaseMessage? messageSent,
    String? errorPhrase,
    String? errorBody,
    FcmError? fcmError,
  }) {
    return ServerResult(
      successful: successful ?? this.successful,
      statusCode: statusCode ?? this.statusCode,
      messageSent: messageSent ?? this.messageSent,
      errorPhrase: errorPhrase ?? this.errorPhrase,
      errorBody: errorBody ?? this.errorBody,
      fcmError: fcmError ?? this.fcmError,
    );
  }

  @override
  String toString() {
    return 'ServerResult{successful: $successful, statusCode: $statusCode, '
        'messageSent: $messageSent, errorPhrase: $errorPhrase, '
        'fcmError: $fcmError}';
  }

  @override
  bool operator ==(covariant ServerResult other) {
    if (identical(this, other)) return true;
    return other.successful == successful &&
        other.statusCode == statusCode &&
        other.messageSent == messageSent &&
        other.errorPhrase == errorPhrase &&
        other.errorBody == errorBody &&
        other.fcmError?.toString() == fcmError?.toString();
  }

  @override
  int get hashCode {
    return successful.hashCode ^
        statusCode.hashCode ^
        messageSent.hashCode ^
        errorPhrase.hashCode ^
        errorBody.hashCode ^
        fcmError.hashCode;
  }
}
