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
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> anticollCard() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int> selectCard() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int> requestCard(int spRequestMode) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int> verifyPwd({
    required String pwd,
    required int sector,
    required int keyMode,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
