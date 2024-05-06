import 'hc_icrf_platform_interface.dart';

class HcIcrf {
  Future<void> connectReader() {
    return HcIcrfPlatform.instance.connectReader();
  }

  Future<void> requestCard(int spRequestMode) {
    return HcIcrfPlatform.instance.requestCard(spRequestMode);
  }

  Future<String> anticollCard() {
    return HcIcrfPlatform.instance.anticollCard();
  }

  Future<int> selectCard() {
    return HcIcrfPlatform.instance.selectCard();
  }

  /**
   * pwd:密码
   * sector:扇区号
   * keyMode:密码模式
   */
  Future<int> verifyPwd({
    required String pwd,
    required int sector,
    required int keyMode,
  }) {
    return HcIcrfPlatform.instance
        .verifyPwd(pwd: pwd, sector: sector, keyMode: keyMode);
  }

  /**
   * 读数据
   * blockNo:块号
   */
  Future<String> readCard({
    required String blockNo,
  }) {
    return HcIcrfPlatform.instance.readCard(blockNo: blockNo);
  }
}
