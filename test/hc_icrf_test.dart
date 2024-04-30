import 'package:flutter_test/flutter_test.dart';
import 'package:hc_icrf/hc_icrf.dart';
import 'package:hc_icrf/hc_icrf_platform_interface.dart';
import 'package:hc_icrf/hc_icrf_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHcIcrfPlatform
    with MockPlatformInterfaceMixin
    implements HcIcrfPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HcIcrfPlatform initialPlatform = HcIcrfPlatform.instance;

  test('$MethodChannelHcIcrf is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHcIcrf>());
  });

  test('getPlatformVersion', () async {
    HcIcrf hcIcrfPlugin = HcIcrf();
    MockHcIcrfPlatform fakePlatform = MockHcIcrfPlatform();
    HcIcrfPlatform.instance = fakePlatform;

    expect(await hcIcrfPlugin.getPlatformVersion(), '42');
  });
}
