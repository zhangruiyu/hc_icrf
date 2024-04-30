package com.mhz.hc_icrf

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import com.hc.reader.AndroidUSB
import io.flutter.plugin.common.MethodChannel

object ConnectReader {
     val Device_USB = "com.android.example.USB"

    fun connectReaderClickListener(
        applicationContext: Context,
        channel: MethodChannel
    ): Pair<AndroidUSB, UsbDevice?>? {
        return try {
            val manager =
                applicationContext.getSystemService(Context.USB_SERVICE) as UsbManager?
            if (manager == null) {
                HcIcrfPlugin.sendErrorMessage(channel, "UsbManager is null.")
                return null
            }
            val card = AndroidUSB(applicationContext, manager)
            val usbDevice = card.GetUsbReader()
            if (usbDevice == null) {
                HcIcrfPlugin.sendErrorMessage(channel, "No reader was scanned.");
                return card to null
            }

            // 判断是否拥有该设备的连接权限
            if (!manager.hasPermission(usbDevice)) {

                // 如果没有则请求权限
                val mPermissionIntent = PendingIntent.getBroadcast(
                    applicationContext, 0,
                    Intent(Device_USB), PendingIntent.FLAG_UPDATE_CURRENT
                )
                manager.requestPermission(usbDevice, mPermissionIntent)
            } else {
                val st = card.OpenReader(usbDevice)
                if (st >= 0) {
                    channel.invokeMethod(
                        "connectReaderSucceeded",
                        emptyMap<String, String>()
                    )
//                    PutMessage("Connect Reader succeeded.")
//                    btnCard.setEnabled(true)
                } else {
                    HcIcrfPlugin.sendErrorMessage(channel, card.GetErrMessage(0.toShort(), st))
                }
            }
            return card to usbDevice
        } catch (e: Exception) {
            HcIcrfPlugin.sendErrorMessage(channel, e.message)
            null
        }
    }

}