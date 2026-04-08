import 'dart:convert';

import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';
import 'package:test/test.dart';

/// Unit tests for firebase_cloud_messaging_flutter v2.0.0
///
/// Run with:
///   dart run build_runner build --delete-conflicting-outputs
///   dart test
void main() {
  // -------------------------------------------------------------------------
  // AndroidMessagePriority serialization (critical regression test)
  // The FCM API requires uppercase "NORMAL" / "HIGH" not lowercase.
  // -------------------------------------------------------------------------
  group('AndroidMessagePriority JSON values', () {
    test('normal serializes to "NORMAL"', () {
      final config = FirebaseAndroidConfig(
        priority: AndroidMessagePriority.normal,
      );
      final map = config.toJson();
      expect(map['priority'], equals('NORMAL'));
    });

    test('high serializes to "HIGH"', () {
      final config = FirebaseAndroidConfig(
        priority: AndroidMessagePriority.high,
      );
      final map = config.toJson();
      expect(map['priority'], equals('HIGH'));
    });

    test('round-trips from JSON', () {
      const input = {'priority': 'HIGH'};
      final config = FirebaseAndroidConfig.fromJson(input);
      expect(config.priority, AndroidMessagePriority.high);
      expect(config.toJson()['priority'], equals('HIGH'));
    });
  });

  // -------------------------------------------------------------------------
  // AndroidNotificationProxy serialization (new in v2.0.0)
  // -------------------------------------------------------------------------
  group('AndroidNotificationProxy JSON values', () {
    test('allow serializes to "ALLOW"', () {
      final notification = FirebaseAndroidNotification(
        proxy: AndroidNotificationProxy.allow,
      );
      final map = notification.toJson();
      expect(map['proxy'], equals('ALLOW'));
    });

    test('deny serializes to "DENY"', () {
      final n = FirebaseAndroidNotification(
        proxy: AndroidNotificationProxy.deny,
      );
      expect(n.toJson()['proxy'], equals('DENY'));
    });
  });

  // -------------------------------------------------------------------------
  // FirebaseAndroidConfig — new field
  // -------------------------------------------------------------------------
  group('FirebaseAndroidConfig', () {
    test('directBootOk serializes to "direct_boot_ok"', () {
      const config = FirebaseAndroidConfig(directBootOk: true);
      expect(config.toJson()['direct_boot_ok'], isTrue);
    });

    test('directBootOk round-trips from JSON', () {
      final config = FirebaseAndroidConfig.fromJson({'direct_boot_ok': false});
      expect(config.directBootOk, isFalse);
    });
  });

  // -------------------------------------------------------------------------
  // FirebaseFcmOptions — new image field
  // -------------------------------------------------------------------------
  group('FirebaseFcmOptions', () {
    test('image field serializes correctly', () {
      const opts = FirebaseFcmOptions(
        analyticsLabel: 'promo',
        image: 'https://example.com/img.png',
      );
      final map = opts.toJson();
      expect(map['analytics_label'], equals('promo'));
      expect(map['image'], equals('https://example.com/img.png'));
    });

    test('round-trips from JSON', () {
      final opts = FirebaseFcmOptions.fromJson({
        'analytics_label': 'test',
        'image': 'https://example.com/a.png',
      });
      expect(opts.analyticsLabel, equals('test'));
      expect(opts.image, equals('https://example.com/a.png'));
    });
  });

  // -------------------------------------------------------------------------
  // FirebaseMessage serialization round-trip
  // -------------------------------------------------------------------------
  group('FirebaseMessage JSON round-trip', () {
    test('basic message serializes and deserializes', () {
      const message = FirebaseMessage(
        token: 'device-token-abc',
        data: {'key': 'value'},
        notification: FirebaseNotification(
          title: 'Hello',
          body: 'World',
          image: 'https://example.com/img.jpg',
        ),
      );

      final encoded = jsonEncode(message.toJson());
      final map = jsonDecode(encoded) as Map<String, dynamic>;
      expect(map['token'], equals('device-token-abc'));
      expect(map['data'], equals({'key': 'value'}));
      expect(map['notification']['title'], equals('Hello'));

      final decoded = FirebaseMessage.fromJson(map);
      expect(decoded.token, equals('device-token-abc'));
      expect(decoded.notification?.title, equals('Hello'));
    });

    test('copyWith replaces only specified fields', () {
      const original = FirebaseMessage(token: 'abc', topic: null);
      final copy = original.copyWith(token: 'xyz');
      expect(copy.token, equals('xyz'));
      expect(copy.topic, isNull);
    });

    test('copyWith(topic:) leaves token unchanged', () {
      const original = FirebaseMessage(token: 'tok');
      final copy = original.copyWith(topic: 'weather');
      // Note: in practice you would set only one target field.
      expect(copy.token, equals('tok'));
      expect(copy.topic, equals('weather'));
    });
  });

  // -------------------------------------------------------------------------
  // FirebaseSend — null message assertion
  // -------------------------------------------------------------------------
  group('FirebaseSend', () {
    test('assert fires when message is null', () {
      expect(
        () => FirebaseSend(message: null),
        throwsA(isA<AssertionError>()),
      );
    });

    test('copyWith replaces validateOnly', () {
      final original = FirebaseSend(
        validateOnly: false,
        message: const FirebaseMessage(token: 'x'),
      );
      final copy = original.copyWith(validateOnly: true);
      expect(copy.validateOnly, isTrue);
      expect(copy.message?.token, equals('x'));
    });

    test('serializes validate_only key', () {
      final send = FirebaseSend(
        validateOnly: true,
        message: const FirebaseMessage(token: 'tok'),
      );
      final map = send.toJson();
      expect(map['validate_only'], isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // FcmError parsing
  // -------------------------------------------------------------------------
  group('FcmError', () {
    test('parses UNREGISTERED from response body', () {
      final body = json.decode('''{
        "error": {
          "code": 404,
          "message": "Requested entity was not found.",
          "status": "UNREGISTERED"
        }
      }''') as Map<String, dynamic>;

      final error = FcmError.fromResponseBody(body);
      expect(error, isNotNull);
      expect(error!.code, equals(404));
      expect(error.errorCode, equals(FcmErrorCode.unregistered));
      expect(error.isRetryable, isFalse);
    });

    test('parses QUOTA_EXCEEDED and marks it retryable', () {
      final body = json.decode('''{
        "error": {
          "code": 429,
          "message": "Quota exceeded.",
          "status": "QUOTA_EXCEEDED"
        }
      }''') as Map<String, dynamic>;

      final error = FcmError.fromResponseBody(body);
      expect(error!.errorCode, equals(FcmErrorCode.quotaExceeded));
      expect(error.isRetryable, isTrue);
    });

    test('parses UNAVAILABLE and marks it retryable', () {
      final body = json.decode('''{
        "error": {
          "code": 503,
          "message": "The service is currently unavailable.",
          "status": "UNAVAILABLE"
        }
      }''') as Map<String, dynamic>;

      final error = FcmError.fromResponseBody(body);
      expect(error!.errorCode, equals(FcmErrorCode.unavailable));
      expect(error.isRetryable, isTrue);
    });

    test('returns null when body has no error key', () {
      final error = FcmError.fromResponseBody({'message': 'some-msg-id'});
      expect(error, isNull);
    });

    test('maps unknown status to FcmErrorCode.unknown', () {
      final body = json.decode('''{
        "error": {
          "code": 999,
          "message": "Future error.",
          "status": "FUTURE_ERROR_CODE"
        }
      }''') as Map<String, dynamic>;

      final error = FcmError.fromResponseBody(body);
      expect(error!.errorCode, equals(FcmErrorCode.unknown));
    });
  });

  // -------------------------------------------------------------------------
  // FcmRetryConfig — delay calculation
  // -------------------------------------------------------------------------
  group('FcmRetryConfig', () {
    test('delayForAttempt doubles on each attempt', () {
      const config = FcmRetryConfig(
        maxRetries: 5,
        initialDelay: Duration(seconds: 1),
        maxDelay: Duration(seconds: 60),
      );
      expect(config.delayForAttempt(0), equals(const Duration(seconds: 1)));
      expect(config.delayForAttempt(1), equals(const Duration(seconds: 2)));
      expect(config.delayForAttempt(2), equals(const Duration(seconds: 4)));
    });

    test('delay is capped at maxDelay', () {
      const config = FcmRetryConfig(
        maxRetries: 10,
        initialDelay: Duration(seconds: 1),
        maxDelay: Duration(seconds: 5),
      );
      // Attempt 3 → 8s, but capped at 5s
      expect(config.delayForAttempt(3), equals(const Duration(seconds: 5)));
    });

    test('FcmRetryConfig.none has maxRetries 0', () {
      expect(FcmRetryConfig.none.maxRetries, equals(0));
    });
  });

  // -------------------------------------------------------------------------
  // BatchResult aggregation
  // -------------------------------------------------------------------------
  group('BatchResult', () {
    ServerResult makeResult({required bool successful, int code = 200}) {
      return ServerResult(
        successful: successful,
        statusCode: successful ? 200 : code,
        messageSent: const FirebaseMessage(),
      );
    }

    test('successCount and failureCount are correct', () {
      final batch = BatchResult(
        results: [
          TokenResult(token: 't1', serverResult: makeResult(successful: true)),
          TokenResult(
              token: 't2',
              serverResult: makeResult(successful: false, code: 404)),
          TokenResult(token: 't3', serverResult: makeResult(successful: true)),
        ],
      );
      expect(batch.successCount, equals(2));
      expect(batch.failureCount, equals(1));
      expect(batch.allSuccessful, isFalse);
      expect(batch.anySuccessful, isTrue);
    });

    test('failedResults contains only failed tokens', () {
      final batch = BatchResult(
        results: [
          TokenResult(token: 't1', serverResult: makeResult(successful: true)),
          TokenResult(token: 't2', serverResult: makeResult(successful: false)),
        ],
      );
      expect(batch.failedResults.length, equals(1));
      expect(batch.failedResults.first.token, equals('t2'));
    });

    test('allSuccessful is true when all succeed', () {
      final batch = BatchResult(
        results: [
          TokenResult(token: 't1', serverResult: makeResult(successful: true)),
          TokenResult(token: 't2', serverResult: makeResult(successful: true)),
        ],
      );
      expect(batch.allSuccessful, isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // ServerResult
  // -------------------------------------------------------------------------
  group('ServerResult', () {
    const result = ServerResult(
      successful: true,
      statusCode: 200,
      messageSent: FirebaseMessage(name: 'projects/p/messages/1'),
    );

    test('copyWith changes only specified fields', () {
      final copy = result.copyWith(statusCode: 500, successful: false);
      expect(copy.successful, isFalse);
      expect(copy.statusCode, equals(500));
      expect(copy.messageSent?.name, equals('projects/p/messages/1'));
    });

    test('toString includes key fields', () {
      expect(result.toString(), contains('successful: true'));
      expect(result.toString(), contains('statusCode: 200'));
    });

    test('equality works', () {
      const same = ServerResult(
        successful: true,
        statusCode: 200,
        messageSent: FirebaseMessage(name: 'projects/p/messages/1'),
      );
      expect(result, equals(same));
    });
  });

  // -------------------------------------------------------------------------
  // FirebaseApnsConfig — Nesting verification
  // -------------------------------------------------------------------------
  group('FirebaseApnsConfig nesting', () {
    test('notification is nested inside payload.aps in toJson()', () {
      final config = FirebaseApnsConfig(
        notification: const FirebaseApnsNotification(
          title: 'APNs Title',
          badge: 5,
        ),
      );

      final json = config.toJson();

      // Should not be at the top level
      expect(json.containsKey('notification'), isFalse);

      // Should be inside payload -> aps
      expect(json['payload'], isNotNull);
      expect(json['payload']['aps'], isNotNull);
      expect(json['payload']['aps']['title'], equals('APNs Title'));
      expect(json['payload']['aps']['badge'], equals(5));
    });

    test('round-trips notification from payload.aps in fromJson()', () {
      final json = {
        'payload': {
          'aps': {
            'title': 'iOS Alert',
            'sound': 'default',
          }
        }
      };

      final config = FirebaseApnsConfig.fromJson(json);

      expect(config.notification, isNotNull);
      expect(config.notification?.title, equals('iOS Alert'));
      expect(config.notification?.sound, equals('default'));
    });

    test('merges notification into existing payload fields', () {
      final config = FirebaseApnsConfig(
        payload: {'custom-key': 'custom-value'},
        notification: const FirebaseApnsNotification(badge: 1),
      );

      final json = config.toJson();

      expect(json['payload']['custom-key'], equals('custom-value'));
      expect(json['payload']['aps']['badge'], equals(1));
    });
  });
}
