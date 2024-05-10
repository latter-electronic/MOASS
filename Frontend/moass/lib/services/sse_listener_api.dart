import 'package:dio/dio.dart';
import 'package:eventflux/client.dart';
import 'package:eventflux/enum.dart';
import 'package:eventflux/eventflux.dart';
import 'package:eventflux/models/data.dart';
import 'package:eventflux/models/reconnect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SSEListener {
  final FlutterSecureStorage storage;

  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  String userEventdata = "";
  String teamEventdata = "";
  int testCount = 0;

  SSEListener({required this.storage});

  // SSE를 위한 이벤트 플럭스 설정
  EventFlux userEvent = EventFlux.spawn();
  EventFlux teamEvent = EventFlux.spawn();

  connectUserEvent() async {
    // First connection - firing up!

    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      // print('No access token available');
      return;
    }
    userEvent.connect(EventFluxConnectionType.get, '$baseUrl/api/stream/user',
        header: {"Authorization": "Bearer $accessToken"},
        onSuccessCallback: (EventFluxResponse? data) {
      data?.stream?.listen((data) {
        testCount++;
        print('유저 이벤트 데이터 : ${data.data.toString()}');
        userEventdata = data.data.toString();

        storage.write(
            key: 'testUserEventresult',
            value: userEventdata + testCount.toString());
        // Your 1st Stream's data is being fetched!
      });
    }, onError: (oops) {
      print('유저 이벤트 연결 실패!');
      userEvent.disconnect();
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
    return userEventdata;
  }

  void disconnectUserEvent() async {
    userEvent.disconnect();
  }

  void connectTeamEvent() async {
// Second connection - firing up!

    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      // print('No access token available');
      return;
    }
    teamEvent.connect(
      EventFluxConnectionType.get,
      '$baseUrl/api/stream/team',
      header: {"Authorization": "Bearer $accessToken"},
      onSuccessCallback: (EventFluxResponse? data) {
        data?.stream?.listen((data) {
          testCount++;
          print('팀 이벤트 데이터 : ${data.data.toString()}');
          teamEventdata = data.data.toString();
          storage.write(
              key: 'testteamEventresult',
              value: teamEventdata + testCount.toString());
          // Your 2nd Stream's data is also being fetched!
        });
      },
      onError: (oops) {
        print('팀 이벤트 연결 실패!');
        teamEvent.disconnect();
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

  void disconnectTeamEvent() async {
    teamEvent.disconnect();
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
