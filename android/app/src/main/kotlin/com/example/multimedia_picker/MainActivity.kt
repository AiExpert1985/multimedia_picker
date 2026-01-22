package com.example.multimedia_picker

import android.app.Activity
import android.content.ContentResolver
import android.content.Intent
import android.content.IntentSender
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.os.StatFs
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.multimedia_picker/media"
    private val DELETE_REQUEST_CODE = 1001
    private var deleteResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getStorageFreeSpace") {
                val freeSpace = getFreeSpace()
                result.success(freeSpace)
            } else if (call.method == "deleteOriginal") {
                val uriString = call.argument<String>("uri")
                if (uriString != null) {
                    deleteOriginal(uriString, result)
                } else {
                    result.error("INVALID_ARGUMENT", "URI cannot be null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getFreeSpace(): Long {
        val path = Environment.getExternalStorageDirectory()
        val stat = StatFs(path.path)
        val blockSize = stat.blockSizeLong
        val availableBlocks = stat.availableBlocksLong
        return availableBlocks * blockSize
    }

    private fun deleteOriginal(uriString: String, result: MethodChannel.Result) {
        val uri = Uri.parse(uriString)
        val contentResolver = contentResolver

        try {
            // Basic deletion for files we own or compatible versions
            val rowsDeleted = contentResolver.delete(uri, null, null)
            if (rowsDeleted > 0) {
                result.success(true)
            } else {
                // If we couldn't delete, it might be because we don't own it or it doesn't exist.
                // For Android 10+ (Q) and Scoped Storage, we might need to request permission via RecoverableSecurityException
                // However, MediaStore.createDeleteRequest is the modern way for Q+ if we are not the owner.
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                     val uris = listOf(uri)
                     val pi = MediaStore.createDeleteRequest(contentResolver, uris)
                     deleteResult = result
                     startIntentSenderForResult(pi.intentSender, DELETE_REQUEST_CODE, null, 0, 0, 0)
                } else {
                    // For older versions or if standard delete failed unexpectedly
                     result.success(false)
                }
            }
        } catch (e: SecurityException) {
            // On Android 10 (Q), RecoverableSecurityException might be thrown if not owner
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val recoverableSecurityException = e as? android.app.RecoverableSecurityException
                if (recoverableSecurityException != null) {
                     deleteResult = result
                     startIntentSenderForResult(
                         recoverableSecurityException.userAction.actionIntent.intentSender,
                         DELETE_REQUEST_CODE,
                         null,
                         0,
                         0,
                         0
                     )
                     return
                }
            }
            result.error("SECURITY_EXCEPTION", e.message, null)
        } catch (e: Exception) {
            result.error("DELETE_FAILED", e.message, null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == DELETE_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                deleteResult?.success(true)
            } else {
                deleteResult?.success(false)
            }
            deleteResult = null
        }
    }
}
