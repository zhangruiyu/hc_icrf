package com.mhz.hc_icrf

import com.hc.reader.AndroidUSB
import com.hc.reader.Utils
import io.flutter.plugin.common.MethodChannel
import java.util.Arrays

object AnticollClickListener {

    fun invoke(
        channel: MethodChannel,
        result: MethodChannel.Result,
        card: AndroidUSB,
        snr: ByteArray,
    ) {
        try {
            Arrays.fill(snr, 0x00.toByte())
            val st: Short = card.rf_anticoll(snr)
            if (st >= 0) {
                HcIcrfPlugin.sendSuccessMessage(
                    channel,
                    "防冲突成功, 返回卡片序列号: " + Utils.byteArrayToHexString(
                        snr,
                        0,
                        st.toInt()
                    )
                )
                result.success(
                    Utils.byteArrayToHexString(
                        snr,
                        0,
                        st.toInt()
                    )
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