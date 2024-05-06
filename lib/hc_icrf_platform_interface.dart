import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hc_icrf_method_channel.dart';

abstract class HcIcrfPlatform extends PlatformInterface {
  /// Constructs a HcIcrfPlatform.
  HcIcrfPlatform() : super(token: _token);

  static final Object _token = Object();

  static HcIcrfPlatform _instance = MethodChannelHcIcrf();

  /// The default instance of [HcIcrfPlatform] to use.
  ///
  /// Defaults to [MethodChannelHcIcrf].
  static HcIcrfPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HcIcrfPlatform] when
  /// they register themselves.
  static set instance(HcIcrfPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> connectReader() {
    throw UnimplementedError('connectReader() has not been implemented.');
  }

  Future<String> anticollCard() {
    throw UnimplementedError('anticollCard() has not been implemented.');
  }

  Future<int> selectCard() {
    throw UnimplementedError('selectCard() has not been implemented.');
  }

  Future<int> requestCard(int spRequestMode) {
    throw UnimplementedError('requestCard() has not been implemented.');
  }

  Future<int> verifyPwd({
    required String pwd,
    required int sector,
    required int keyMode,
  }) {
    throw UnimplementedError('verifyPwd() has not been implemented.');
  }

  Future<String> readCard({
    required String blockNo,
  }) {
    throw UnimplementedError('readCard() has not been implemented.');
  }

  Future<bool> writeCard({
    required String blockNo,
    required String blockData,
  }) {
    throw UnimplementedError('writeCard() has not been implemented.');
  }

  Future<bool> initValue({
    required String blockNo,
    required String initValue,
  }) {
    throw UnimplementedError('initValue() has not been implemented.');
  }

  Future<bool> decrement({
    required String blockNo,
    required String value,
  }) {
    throw UnimplementedError('decrement() has not been implemented.');
  }

  Future<bool> increment({
    required String blockNo,
    required String value,
  }) {
    throw UnimplementedError('increment() has not been implemented.');
  }

  Future<int> readValue({
    required String blockNo,
  }) {
    throw UnimplementedError('readValue() has not been implemented.');
  }

  Future<bool> closeCard() {
    throw UnimplementedError('closeCard() has not been implemented.');
  }
}
