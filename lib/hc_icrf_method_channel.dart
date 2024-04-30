import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hc_icrf_platform_interface.dart';

/// An implementation of [HcIcrfPlatform] that uses method channels.
class MethodChannelHcIcrf extends HcIcrfPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hc_icrf');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
