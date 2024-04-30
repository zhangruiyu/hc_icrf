package com.mhz.hc_icrf

import com.hc.reader.AndroidUSB
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

object RequestCardClickListener {
    fun requestCard(
        channel: MethodChannel,
        result: Result,
        card: AndroidUSB,
        spRequestMode: Int
    ) {
        try {
            val mode: Byte = spRequestMode.toByte()
            val st: Short = card.rf_request(mode)
            if (st >= 0) {
                HcIcrfPlugin.sendSuccessMessage(
                    channel,
                    "请求卡片成功, 返回卡类型代码: $st"
                )
                return result.success(st.toInt())
            } else {
                HcIcrfPlugin.sendErrorMessage(channel, card.GetErrMessage(0, st))
                result.error(st.toString(), card.GetErrMessage(0.toShort(), st), null)
            }
        } catch (e: Exception) {
            HcIcrfPlugin.sendErrorMessage(channel, e.message)
            result.error("3000", e.message, e.stackTraceToString())
        }
    }
}