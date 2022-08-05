import 'dart:convert';
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';

/// Send Firebase Cloud Messages directly from your Dart or Flutter App
class FirebaseCloudMessagingServer {
  ///Firebase console:
  ///open settings > Service Accounts
  ///Generate New Private Key > Generate Key
  /// Open Your Json file and Copy all the code.
  final Map<String, dynamic> firebaseServiceCredentials;

  ///Caches authCredentials(up to 1 hour)
  final bool cacheAuth;

  AccessCredentials? accessCredentials;

  FirebaseCloudMessagingServer(
    this.firebaseServiceCredentials, {
    this.cacheAuth = true,
  });

  Future<AccessCredentials?> performAuth() async {
    /// Get Service Account Credentials from Given Map
    final ServiceAccountCredentials accountCredentials =
        ServiceAccountCredentials.fromJson(
      firebaseServiceCredentials,
    );

    /// We only required messaging scope to send messages
    final List<String> scopes = <String>[
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    /// Create a instance of HTTP Client to perform server request
    final Client client = Client();

    /// Get Access to Requested Scop via service account details
    accessCredentials = await obtainAccessCredentialsViaServiceAccount(
      accountCredentials,
      scopes,
      client,
    );

    /// Close Http server request
    client.close();

    /// send acess credentials
    return accessCredentials;
  }

  /// Send Only One Message
  Future<ServerResult> send(FirebaseSend ob) async => await _send(ob);

  /// Send Multiple Messages at once
  Future<List<ServerResult>> sendMessages(
    List<FirebaseSend> sendObjects,
  ) async {
    // Create a list and Hold Messages sent result
    final List<ServerResult> results = [];
    // Send all message one by one and add sent result in `results` lsit
    for (FirebaseSend sendObject in sendObjects) {
      results.add((await _send(sendObject)));
    }
    // return sent messages results
    return results;
  }

  /// Perform Send Message Request
  Future<ServerResult> _send(FirebaseSend sendObject) async {
    // Make sure access credentials aren't null and access token isn't expired
    // if access token is expired and send a request for fresh access token
    if (accessCredentials == null ||
        DateTime.now().isAfter(accessCredentials!.accessToken.expiry) ||
        !cacheAuth) {
      /// perform access token request
      await performAuth();
    }

    /// Send Message Request and Save it's response
    final Response response = await Client().post(
      Uri.parse(
        'https://fcm.googleapis.com/v1/projects/${FirebaseServiceModel.fromJson(firebaseServiceCredentials).projectID}/messages:send',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessCredentials!.accessToken.data}'
      },
      body: json.encode(sendObject.toJson()),
    );

    /// Get request response
    final bool successful = response.statusCode == 200;

    /// Print Request response
    print('successful: $successful');

    /// Get Server Request result from Request Body [response.body]
    final ServerResult serverResult = ServerResult(
      successful: successful,
      statusCode: response.statusCode,
      errorPhrase: response.reasonPhrase,
      messageSent: successful
          ? FirebaseMessage.fromJson(json.decode(response.body))
          : FirebaseMessage(),
    );

    /// Print Server Response in console
    print(serverResult);

    /// return server responses
    return serverResult;
  }
}

/// Hold Message request response
class ServerResult {
  final bool successful;
  final int statusCode;
  final FirebaseMessage messageSent;
  final String? errorPhrase;

  const ServerResult({
    required this.successful,
    required this.statusCode,
    required this.messageSent,
    this.errorPhrase,
  });

  @override
  String toString() {
    return 'ServerResult{successful: $successful, statusCode: $statusCode, messageSent: $messageSent, errorPhrase: $errorPhrase}';
  }

  @override
  bool operator ==(covariant ServerResult other) {
    if (identical(this, other)) return true;

    return other.successful == successful &&
        other.statusCode == statusCode &&
        other.messageSent == messageSent &&
        other.errorPhrase == errorPhrase;
  }

  @override
  int get hashCode {
    return successful.hashCode ^
        statusCode.hashCode ^
        messageSent.hashCode ^
        errorPhrase.hashCode;
  }
}
