import 'hc_icrf_platform_interface.dart';

class HcIcrf {

  /**
   * 连接读卡器
   */
  Future<void> connectReader() {
    return HcIcrfPlatform.instance.connectReader();
  }

  /**
   * 请求卡片
   * spRequestMode:请求模式
   */
  Future<void> requestCard(int spRequestMode) {
    return HcIcrfPlatform.instance.requestCard(spRequestMode);
  }

  /**
   * 放冲突
   */
  Future<String> anticollCard() {
    return HcIcrfPlatform.instance.anticollCard();
  }

  /**
   * 选择卡片
   */
  Future<int> selectCard() {
    return HcIcrfPlatform.instance.selectCard();
  }

  /**
   * 校验密码
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

  /**
   * 写数据
   * blockNo:块号
   * blockData:写入的数据
   */
  Future<bool> writeCard({
    required String blockNo,
    required String blockData,
  }) {
    return HcIcrfPlatform.instance
        .writeCard(blockNo: blockNo, blockData: blockData);
  }

  /**
   * 初始化值
   * blockNo:块号
   * initValue:初始化的数据
   */
  Future<bool> initValue({
    required String blockNo,
    required String initValue,
  }) {
    return HcIcrfPlatform.instance
        .initValue(blockNo: blockNo, initValue: initValue);
  }

  /**
   * 减值
   * blockNo:块号
   * value:数据
   */
  Future<bool> decrement({
    required String blockNo,
    required String value,
  }) {
    return HcIcrfPlatform.instance.decrement(blockNo: blockNo, value: value);
  }

  /**
   * 加值
   * blockNo:块号
   * value:数据
   */
  Future<bool> increment({
    required String blockNo,
    required String value,
  }) {
    return HcIcrfPlatform.instance.increment(blockNo: blockNo, value: value);
  }

  /**
   * 读值
   * blockNo:块号
   */
  Future<int> readValue({
    required String blockNo,
  }) {
    return HcIcrfPlatform.instance.readValue(blockNo: blockNo);
  }

  /**
   * 关闭卡片
   */
  Future<bool> closeCard() {
    return HcIcrfPlatform.instance.closeCard();
  }
}
