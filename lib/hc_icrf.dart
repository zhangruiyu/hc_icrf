import 'hc_icrf_platform_interface.dart';

class HcIcrf {
  Future<void> connectReader() {
    return HcIcrfPlatform.instance.connectReader();
  }
}
