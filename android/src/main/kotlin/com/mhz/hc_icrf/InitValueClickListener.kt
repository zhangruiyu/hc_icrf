package com.mhz.hc_icrf

import com.hc.reader.AndroidUSB
import com.hc.reader.Utils
import io.flutter.plugin.common.MethodChannel

object InitValueClickListener {

    fun invoke(
        channel: MethodChannel,
        result: MethodChannel.Result,
        card: AndroidUSB,
        blockNo: String,
        initValue: String,
    ) {
        try {
            val st: Short = card.rf_initVal(blockNo.toByte(), initValue.toLong())
            if (st >= 0) {
                HcIcrfPlugin.sendSuccessMessage(
                    channel,
                    "初始化值成功"
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