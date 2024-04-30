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
  "error": (Map? argument) => ErrorNativeResponse.fromMap(argument),
};

typedef NativeResponse _NativeResponseInvoker(Map? argument);

class ConnectReaderSucceededNativeResponse extends NativeResponse {
  ConnectReaderSucceededNativeResponse.fromMap(Map? map) : super._(map);
}

class ErrorNativeResponse extends NativeResponse {
  ErrorNativeResponse.fromMap(Map? map) : super._(map);
}
