import 'package:dio/dio.dart';
import 'package:eventflux/client.dart';
import 'package:eventflux/enum.dart';
import 'package:eventflux/eventflux.dart';
import 'package:eventflux/models/reconnect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SSEListener {
  final Dio dio;
  final FlutterSecureStorage storage;

  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  SSEListener({required this.dio, required this.storage});

  // SSE를 위한 이벤트 플럭스 설정

  void connectUserEvent() async {
    EventFlux userEvent = EventFlux.spawn();
    // First connection - firing up!

    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      // print('No access token available');
      return;
    }
    userEvent.connect(EventFluxConnectionType.get,
        'https://k10e203.p.ssafy.io/api/stream/user',
        onSuccessCallback: (EventFluxResponse? data) {
      data?.stream?.listen((data) {
        // Your 1st Stream's data is being fetched!
      });
    }, onError: (oops) {
      // Oops! Time to handle those little hiccups.
      // You can also choose to disconnect here
    },
        autoReconnect: true, // Keep the party going, automatically!
        reconnectConfig: ReconnectConfig(
            mode: ReconnectMode.exponential, // or linear,
            interval: const Duration(seconds: 5),
            maxAttempts: 5, // or -1 for infinite,
            onReconnect: () {
              // Things to execute when reconnect happens
              // FYI: for network changes, the `onReconnect` will not be called.
              // It will only be called when the connection is interupted by the server and eventflux is trying to re-establish the connection.
            }));
  }

  void openTeamEvent() async {
// Second connection - firing up!

    EventFlux teamEvent = EventFlux.spawn();

    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      // print('No access token available');
      return;
    }
    teamEvent.connect(
      EventFluxConnectionType.get,
      'https://k10e203.p.ssafy.io/api/stream/team',
      onSuccessCallback: (EventFluxResponse? data) {
        data?.stream?.listen((data) {
          print('이벤트 수신!');
          // Your 2nd Stream's data is also being fetched!
        });
      },
      onError: (oops) {
        // Oops! Time to handle those little hiccups.
        // You can also choose to disconnect here
      },

      autoReconnect: true, // Keep the party going, automatically!
      reconnectConfig: ReconnectConfig(
          mode: ReconnectMode.exponential, // or linear,
          interval: const Duration(seconds: 5),
          maxAttempts: 5, // or -1 for infinite,
          onReconnect: () {
            // Things to execute when reconnect happens
            // FYI: for network changes, the `onReconnect` will not be called.
            // It will only be called when the connection is interupted by the server and eventflux is trying to re-establish the connection.
          }),
    );
  }

  void openClassEvent() async {
    EventFlux classEvent = EventFlux.spawn();

    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      // print('No access token available');
      return;
    }
    classEvent.connect(
      EventFluxConnectionType.get,
      'https://k10e203.p.ssafy.io/api/stream/class',
      onSuccessCallback: (EventFluxResponse? data) {
        data?.stream?.listen((data) {
          // Your 2nd Stream's data is also being fetched!
        });
      },
      onError: (oops) {
        // Oops! Time to handle those little hiccups.
        // You can also choose to disconnect here
      },

      autoReconnect: true, // Keep the party going, automatically!
      reconnectConfig: ReconnectConfig(
          mode: ReconnectMode.exponential, // or linear,
          interval: const Duration(seconds: 5),
          maxAttempts: 5, // or -1 for infinite,
          onReconnect: () {
            // Things to execute when reconnect happens
            // FYI: for network changes, the `onReconnect` will not be called.
            // It will only be called when the connection is interupted by the server and eventflux is trying to re-establish the connection.
          }),
    );
  }
}
