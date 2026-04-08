import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_cloud_messaging_dart/firebase_cloud_messaging_dart.dart';

/// Internal utility for managing FCM topics via the Firebase Instance ID API.
///
/// This implements the server-side subscription and unsubscription logic
/// using the standard logic from the IID batch API.
class FcmTopicManagement {
  // ---------------------------------------------------------------------------
  // Endpoints
  // ---------------------------------------------------------------------------

  /// The endpoint for the IID batch registration API (Subscribe).
  static const String iidBatchAddEndpoint =
      'https://iid.googleapis.com/iid/v1:batchAdd';

  /// The endpoint for the IID batch registration API (Unsubscribe).
  static const String iidBatchRemoveEndpoint =
      'https://iid.googleapis.com/iid/v1:batchRemove';

  // ---------------------------------------------------------------------------
  // Internal API
  // ---------------------------------------------------------------------------

  /// Performs a batch subscribe or unsubscribe operation.
  ///
  /// [topic] — the topic name (without `/topics/` prefix).
  /// [tokens] — list of device registration tokens (max 1000).
  /// [accessToken] — a valid OAuth 2.0 access token with FCM scopes.
  /// [client] — the HTTP client to use for the request.
  /// [isSubscription] — true to subscribe, false to unsubscribe.
  static Future<TopicManagementResult> performBatchOperation({
    required String topic,
    required List<String> tokens,
    required String accessToken,
    required http.Client client,
    required bool isSubscription,
    FcmLogger? logger,
  }) async {
    final action = isSubscription ? 'batchAdd' : 'batchRemove';
    final url = Uri.parse(
      isSubscription ? iidBatchAddEndpoint : iidBatchRemoveEndpoint,
    );

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      // IID endpoint enforces this explicit header when using OAuth 2.0 tokens
      // rather than legacy Server Keys.
      'access_token_auth': 'true',
    };

    final body = json.encode({
      'to': '/topics/$topic',
      'registration_tokens': tokens,
    });

    logger?.call(
      FcmLogLevel.debug,
      'Topic Management: $action for ${tokens.length} tokens on topic: $topic',
    );

    final response = await client.post(url, headers: headers, body: body);

    Map<String, dynamic> bodyMap;
    try {
      bodyMap = json.decode(response.body) as Map<String, dynamic>;
    } catch (_) {
      // Failsafe in case Google API returns a non-JSON HTML blob.
      bodyMap = {};
    }

    return TopicManagementResult.fromJson(bodyMap, tokens);
  }
}
