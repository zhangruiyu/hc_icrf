package com.mhz.hc_icrf

import com.hc.reader.AndroidUSB
import com.hc.reader.Utils
import io.flutter.plugin.common.MethodChannel

object WriteCardClickListener {

    fun invoke(
        channel: MethodChannel,
        result: MethodChannel.Result,
        card: AndroidUSB,
        blockNo: String,
        blockData: String,
    ) {
        try {
            val data = Utils.hexStringToByteArray(blockData)
            val st: Short = card.rf_write(blockNo.toByte(), data)
            if (st >= 0) {
                HcIcrfPlugin.sendSuccessMessage(
                    channel,
                    "写卡成功"
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