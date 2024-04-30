
import 'hc_icrf_platform_interface.dart';

class HcIcrf {
  Future<String?> getPlatformVersion() {
    return HcIcrfPlatform.instance.getPlatformVersion();
  }
}
