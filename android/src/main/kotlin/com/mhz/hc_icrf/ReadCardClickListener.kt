package com.mhz.hc_icrf

import com.hc.reader.AndroidUSB
import com.hc.reader.Utils
import io.flutter.plugin.common.MethodChannel

object ReadCardClickListener {

    fun invoke(
        channel: MethodChannel,
        result: MethodChannel.Result,
        card: AndroidUSB,
        blockNo: String,
    ) {
        try {
            val data = ByteArray(16)
            val st: Short = card.rf_read(blockNo.toByte(), data)
            if (st >= 0) {
                val cardReadResult = Utils.byteArrayToHexString(data, 0, st.toInt())
                HcIcrfPlugin.sendSuccessMessage(
                    channel,
                    "读卡成功, 返回卡片: $cardReadResult"
                )
                result.success(
                    cardReadResult
                )
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