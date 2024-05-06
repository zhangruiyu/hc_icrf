package com.mhz.hc_icrf

import com.hc.reader.AndroidUSB
import io.flutter.plugin.common.MethodChannel

object IncrementClickListener {

    fun invoke(
        channel: MethodChannel,
        result: MethodChannel.Result,
        card: AndroidUSB,
        blockNo: String,
        value: String,
    ) {
        try {
            val st: Short = card.rf_increment(blockNo.toByte(), value.toLong())
            if (st >= 0) {
                HcIcrfPlugin.sendSuccessMessage(
                    channel,
                    "加值成功"
                )
                result.success(true)
            } else {
                HcIcrfPlugin.sendErrorMessage(channel, card.GetErrMessage(0.toShort(), st))
                result.error(st.toString(), card.GetErrMessage(0.toShort(), st), null)
            }

        } catch (e: java.lang.Exception) {
            HcIcrfPlugin.sendErrorMessage(channel, e.message)
            result.error("3000", e.message, e.stackTraceToString())
        }
    }
}