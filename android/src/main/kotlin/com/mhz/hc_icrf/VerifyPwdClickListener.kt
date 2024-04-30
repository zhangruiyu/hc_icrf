package com.mhz.hc_icrf

import com.hc.reader.AndroidUSB
import com.hc.reader.Utils
import io.flutter.plugin.common.MethodChannel

object VerifyPwdClickListener {

    fun invoke(
        channel: MethodChannel,
        result: MethodChannel.Result,
        card: AndroidUSB,
        strPwd: String,
        etSector: Int,
        spPwdMode: Int,
    ) {
        try {
            val btPwd = Utils.hexStringToByteArray(strPwd)
            val secNo: Byte = etSector.toByte()
            var keyMode: Byte = spPwdMode.toByte()
            if (keyMode.toInt() == 1) {
                keyMode = 4
            }
            val st: Short = card.rf_authentication(keyMode, secNo, btPwd)
            if (st >= 0) {
                HcIcrfPlugin.sendSuccessMessage(
                    channel, "$secNo 扇区校验密码成功."
                )
                result.success(
                    secNo.toInt()
                )
            } else {
                HcIcrfPlugin.sendErrorMessage(channel, card.GetErrMessage(0.toShort(), st))
                result.error(st.toString(), card.GetErrMessage(0.toShort(), st), null)
            }
        } catch (e: Exception) {
            HcIcrfPlugin.sendErrorMessage(channel, e.message)
            result.error("3000", e.message, e.stackTraceToString())
        }
    }
}