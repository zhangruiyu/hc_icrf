package com.mhz.hc_icrf

import android.app.Activity
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.util.Log
import android.widget.Toast
import com.hc.reader.AndroidUSB
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** HcIcrfPlugin */
class HcIcrfPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private val TAG: String = HcIcrfPlugin::class.java.getSimpleName()
    private val Device_USB = "com.android.example.USB"

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context
    lateinit var activity: Activity
    lateinit var card: AndroidUSB
    lateinit var usbDevice: UsbDevice
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.applicationContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "hc_icrf")
        channel.setMethodCallHandler(this)
        /*
                 * 在使用USB读写器设备前，应用必须获得权限。
                 * 为了确切地获得权限，首先需要创建一个广播接收器。在调用requestPermission()这个方法时从得到的广播中监听这个意图。
                 * 通过调用requestPermission()这个方法为用户跳出一个是否连接该设备的对话框。
                 */
        val filter = IntentFilter(Device_USB)
        activity.registerReceiver(mUsbBroadcast, filter)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "connectReader" -> {
                connectReaderClickListener()
                result.success(true)
            }

            "close" -> {
                // Destroy broadcasts.

                result.success(true)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        applicationContext.unregisterReceiver(mUsbBroadcast)
    }


    fun connectReaderClickListener() {
        try {
            val manager =
                applicationContext.getSystemService(Context.USB_SERVICE) as UsbManager?
            if (manager == null) {
                sendError("UsbManager is null.")
                return
            }
            card = AndroidUSB(applicationContext, manager)
            val usbDevice = card.GetUsbReader()
            if (usbDevice == null) {
                sendError("No reader was scanned.");
                return
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
                    sendError(card.GetErrMessage(0.toShort(), st))
                }
            }
        } catch (e: Exception) {
            sendError(e.message)
        }
    }

    /**
     * Create a broadcast receiver.
     */
    private val mUsbBroadcast: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(paramAnonymousContext: Context, paramAnonymousIntent: Intent) {
            Log.w(TAG, "Enter the broadcast receiver.")
            val action = paramAnonymousIntent.action
            // 判断广播类型
            if (Device_USB == action) {
                try {
                    // 如果用户同意，则对读写器进行操作
                    if (paramAnonymousIntent.getBooleanExtra(
                            UsbManager.EXTRA_PERMISSION_GRANTED,
                            false
                        )
                    ) {
                        val st: Short = card.OpenReader(usbDevice)
                        if (st >= 0) {
                            channel.invokeMethod(
                                "connectReaderSucceeded",
                                emptyMap<String, String>()
                            )
//                            PutMessage("Connect Reader succeeded.")
//                            btnCard.setEnabled(true)
                        } else {
                            sendError(card.GetErrMessage(0.toShort(), st))
//                            PutMessage(card.GetErrMessage(0.toShort(), st))
                        }
                    } else {
                        //Toast.makeText(MainActivity.this, "Rejected.", Toast.LENGTH_LONG).show();
                    }
                } catch (e: java.lang.Exception) {
                    Toast.makeText(applicationContext, e.message, Toast.LENGTH_LONG).show()
                }
            }
        }
    }

    fun sendError(message: String?) {
        channel.invokeMethod("error", mapOf("message" to message))
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }
}
