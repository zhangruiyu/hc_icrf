package com.mhz.hc_icrf

import com.hc.reader.AndroidUSB
import io.flutter.plugin.common.MethodChannel

object SelectCardClickListener {

    fun invoke(
        channel: MethodChannel,
        result: MethodChannel.Result,
        card: AndroidUSB,
        snr: ByteArray,
    ) {
        try {
            val st: Short = card.rf_select(snr)
            if (st >= 0) {
                HcIcrfPlugin.sendSuccessMessage(
                    channel,
                    "选卡成功, 返回卡片容量: $st"
                )
                result.success(
                    st.toInt()
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