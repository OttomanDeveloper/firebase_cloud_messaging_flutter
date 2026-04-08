// Retry configuration for FCM send operations.
//
// Pass a [FcmRetryConfig] to [FirebaseCloudMessagingServer] to enable
// automatic exponential back-off for retryable FCM errors such as
// `QUOTA_EXCEEDED` and `UNAVAILABLE`.
//
// Example:
// ```dart
// final server = FirebaseCloudMessagingServer(
//   credentials,
//   retryConfig: FcmRetryConfig(maxRetries: 3, initialDelay: Duration(seconds: 1)),
// );
// ```

// ---------------------------------------------------------------------------
// Retry configuration
// ---------------------------------------------------------------------------

/// Controls how [FirebaseCloudMessagingServer] retries failed send requests.
final class FcmRetryConfig {

  const FcmRetryConfig({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
  }) : assert(maxRetries >= 0, 'maxRetries must be non-negative');
  /// Maximum number of retry attempts after the first failure.
  ///
  /// Set to `0` to disable retries entirely. Defaults to `3`.
  final int maxRetries;

  /// Delay before the **first** retry. Each subsequent retry doubles this
  /// value (exponential back-off). Defaults to 1 second.
  final Duration initialDelay;

  /// Hard cap on the delay between retries regardless of how many retries
  /// have been attempted. Defaults to 30 seconds.
  final Duration maxDelay;

  /// A convenient preset that disables all retry behaviour.
  static const FcmRetryConfig none = FcmRetryConfig(maxRetries: 0);

  /// Calculates the delay for the given [attempt] (0-indexed) using
  /// exponential back-off capped at [maxDelay].
  Duration delayForAttempt(int attempt) {
    // 2^attempt * initialDelay, bounded by maxDelay
    final int multiplier = 1 << attempt; // 2^attempt
    final int rawMs = initialDelay.inMilliseconds * multiplier;
    final int cappedMs = rawMs.clamp(0, maxDelay.inMilliseconds);
    return Duration(milliseconds: cappedMs);
  }

  @override
  String toString() =>
      'FcmRetryConfig{maxRetries: $maxRetries, initialDelay: $initialDelay, maxDelay: $maxDelay}';
}
