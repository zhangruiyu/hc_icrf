import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hc_icrf_platform_interface.dart';

/// An implementation of [HcIcrfPlatform] that uses method channels.
class MethodChannelHcIcrf extends HcIcrfPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hc_icrf')
    ..setMethodCallHandler(_methodHandler);

  static final _onDartMessageListener =
      StreamController<NativeResponse>.broadcast();

  static Stream<NativeResponse> get onDartMessageListener =>
      _onDartMessageListener.stream;

  static Future _methodHandler(MethodCall methodCall) {
    var response =
        NativeResponse.create(methodCall.method, methodCall.arguments);
    _onDartMessageListener.add(response);
    return Future.value();
  }

  @override
  Future<void> connectReader() async {
    await methodChannel.invokeMethod<bool>('connectReader');
  }

  @override
  Future<String> anticollCard() async {
    return (await methodChannel.invokeMethod<String>('anticollCard'))!;
  }

  @override
  Future<int> selectCard() async {
    return (await methodChannel.invokeMethod<int>('selectCard'))!;
  }

  @override
  Future<int> requestCard(int spRequestMode) async {
    return (await methodChannel
        .invokeMethod<int>('requestCard', {'spRequestMode': spRequestMode}))!;
  }

  @override
  Future<int> verifyPwd({
    required String pwd,
    required int sector,
    required int keyMode,
  }) async {
    return (await methodChannel.invokeMethod<int>('verifyPwd', {
      'pwd': pwd,
      'sector': sector,
      'keyMode': keyMode,
    }))!;
  }

  @override
  Future<String> readCard({
    required String blockNo,
  }) async {
    return (await methodChannel.invokeMethod<String>('readCard', {
      'blockNo': blockNo,
    }))!;
  }

  @override
  Future<bool> writeCard({
    required String blockNo,
    required String blockData,
  }) async {
    return (await methodChannel.invokeMethod<bool>('writeCard', {
      'blockNo': blockNo,
      'blockData': blockData,
    }))!;
  }

  @override
  Future<bool> initValue({
    required String blockNo,
    required String initValue,
  }) async {
    return (await methodChannel.invokeMethod<bool>('initValue', {
      'blockNo': blockNo,
      'initValue': initValue,
    }))!;
  }

  @override
  Future<bool> decrement({
    required String blockNo,
    required String value,
  }) async {
    return (await methodChannel.invokeMethod<bool>('decrement', {
      'blockNo': blockNo,
      'value': value,
    }))!;
  }

  @override
  Future<bool> increment({
    required String blockNo,
    required String value,
  }) async {
    return (await methodChannel.invokeMethod<bool>('increment', {
      'blockNo': blockNo,
      'value': value,
    }))!;
  }

  @override
  Future<int> readValue({
    required String blockNo,
  }) async {
    return (await methodChannel.invokeMethod<int>('readValue', {
      'blockNo': blockNo,
    }))!;
  }

  @override
  Future<bool> closeCard() async {
    return (await methodChannel.invokeMethod<bool>('closeCard'))!;
  }
  @override
  Future<String> rfScard() async {
    return (await methodChannel.invokeMethod<String>('rfScard'))!;
  }
}

class NativeResponse {
  final dynamic params;

  NativeResponse._(this.params);

  /// create response from response pool
  factory NativeResponse.create(String name, Map? argument) =>
      _nameAndResponseMapper[name]!(argument);

  @override
  String toString() {
    return params.toString();
  }
}

Map<String, _NativeResponseInvoker> _nameAndResponseMapper = {
  "connectReaderSucceeded": (Map? argument) =>
      ConnectReaderSucceededNativeResponse.fromMap(argument),
  "errorMessage": (Map? argument) => ErrorNativeResponse.fromMap(argument),
  "successMessage": (Map? argument) => ErrorNativeResponse.fromMap(argument),
};

typedef NativeResponse _NativeResponseInvoker(Map? argument);

class ConnectReaderSucceededNativeResponse extends NativeResponse {
  ConnectReaderSucceededNativeResponse.fromMap(Map? map) : super._(map);
}

class ErrorNativeResponse extends NativeResponse {
  ErrorNativeResponse.fromMap(Map? map) : super._(map);
}
