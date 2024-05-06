package com.mhz.hc_icrf

import com.hc.reader.AndroidUSB
import io.flutter.plugin.common.MethodChannel

object ReadValueClickListener {

    fun invoke(
        channel: MethodChannel,
        result: MethodChannel.Result,
        card: AndroidUSB,
        blockNo: String,
    ) {
        try {
            val lg  = card.rf_readVal(blockNo.toByte())
            if (lg >= 0) {
                HcIcrfPlugin.sendSuccessMessage(
                    channel,
                    "读值成功,读出的值: $lg"
                )
                result.success(lg)
            } else {
                HcIcrfPlugin.sendErrorMessage(channel, card.GetErrMessage(0.toShort(), lg.toShort()))
                result.error(lg.toString(), card.GetErrMessage(0.toShort(), lg.toShort()), null)
            }

        } catch (e: java.lang.Exception) {
            HcIcrfPlugin.sendErrorMessage(channel, e.message)
            result.error("3000", e.message, e.stackTraceToString())
        }
    }
}