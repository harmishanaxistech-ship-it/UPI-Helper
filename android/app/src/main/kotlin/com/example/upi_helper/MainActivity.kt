package com.example.upi_helper

import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "flutter_upi_helper"
    private var pendingResult: MethodChannel.Result? = null
    private val UPI_PAYMENT_REQUEST_CODE = 123

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApps" -> {
                    val apps = getInstalledUpiApps()
                    result.success(apps)
                }
                "launchPayment" -> {
                    val uri = call.argument<String>("uri")
                    val packageName = call.argument<String>("packageName")
                    if (uri != null) {
                        launchUpiIntent(uri, packageName, result)
                    } else {
                        result.error("INVALID_PARAMS", "URI is null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getInstalledUpiApps(): List<Map<String, Any?>> {
        val upiIntent = Intent(Intent.ACTION_VIEW)
        upiIntent.data = Uri.parse("upi://pay")
        
        val pm = packageManager
        val resolveInfoList = pm.queryIntentActivities(upiIntent, PackageManager.MATCH_DEFAULT_ONLY)
        
        val apps = mutableListOf<Map<String, Any?>>()
        for (resolveInfo in resolveInfoList) {
            val appMap = mutableMapOf<String, Any?>()
            val packageName = resolveInfo.activityInfo.packageName
            val name = resolveInfo.loadLabel(pm).toString()
            
            appMap["name"] = name
            appMap["packageName"] = packageName
            
            try {
                val icon = resolveInfo.loadIcon(pm)
                appMap["icon"] = drawableToByteArray(icon)
            } catch (e: Exception) {
                appMap["icon"] = null
            }
            
            apps.add(appMap)
        }
        return apps
    }

    private fun launchUpiIntent(uri: String, packageName: String?, result: MethodChannel.Result) {
        pendingResult = result
        val intent = Intent(Intent.ACTION_VIEW)
        intent.data = Uri.parse(uri)
        
        if (packageName != null && packageName.isNotEmpty()) {
            intent.setPackage(packageName)
        }

        try {
            startActivityForResult(intent, UPI_PAYMENT_REQUEST_CODE)
        } catch (e: Exception) {
            pendingResult?.error("APP_NOT_INSTALLED", "UPI app not installed", null)
            pendingResult = null
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == UPI_PAYMENT_REQUEST_CODE) {
            if (data != null) {
                val response = data.getStringExtra("response")
                if (response != null) {
                    pendingResult?.success(response)
                } else {
                    // Some apps might return data via Uri
                    val uriResponse = data.data?.toString()
                    if (uriResponse != null) {
                        pendingResult?.success(uriResponse)
                    } else {
                        // Handle case where app returns no data but was successful/cancelled
                        val bundle = data.extras
                        if (bundle != null) {
                            val responseStr = bundle.keySet().joinToString("&") { key ->
                                "$key=${bundle.get(key)}"
                            }
                            pendingResult?.success(responseStr)
                        } else {
                            pendingResult?.success("status=failed")
                        }
                    }
                }
            } else {
                pendingResult?.success("status=cancelled")
            }
            pendingResult = null
        }
    }

    private fun drawableToByteArray(drawable: Drawable): ByteArray {
        val bitmap = if (drawable is BitmapDrawable) {
            drawable.bitmap
        } else {
            val width = if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 1
            val height = if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 1
            val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            bitmap
        }
        
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        return stream.toByteArray()
    }
}
