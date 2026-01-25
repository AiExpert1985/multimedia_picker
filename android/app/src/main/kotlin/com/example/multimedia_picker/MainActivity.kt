package com.example.multimedia_picker

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.os.StatFs
import android.provider.MediaStore
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.multimedia_picker/media"
    private val DELETE_REQUEST_CODE = 1001
    private var deleteResult: MethodChannel.Result? = null
    private val TAG = "MediaPicker"

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
                    result.error("URI_INVALID", "URI cannot be null", null)
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
        Log.d(TAG, "deleteOriginal called with URI: $uriString")
        
        val uri: Uri
        try {
            uri = Uri.parse(uriString)
            if (uri.scheme == null) {
                Log.e(TAG, "URI has no scheme: $uriString")
                result.error("URI_INVALID", "Invalid URI format: missing scheme", null)
                return
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to parse URI: $uriString", e)
            result.error("URI_INVALID", "Failed to parse URI: ${e.message}", null)
            return
        }

        Log.d(TAG, "Parsed URI - scheme: ${uri.scheme}, authority: ${uri.authority}, path: ${uri.path}")

        // For Android R+ (11+), always use MediaStore.createDeleteRequest for content URIs
        // since apps don't own gallery files and contentResolver.delete() will fail
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R && uri.scheme == "content") {
            Log.d(TAG, "Using MediaStore.createDeleteRequest for Android R+")
            try {
                // Verify the URI exists in MediaStore before requesting deletion
                val cursor = contentResolver.query(uri, arrayOf(MediaStore.MediaColumns._ID), null, null, null)
                if (cursor == null || !cursor.moveToFirst()) {
                    cursor?.close()
                    Log.e(TAG, "File not found in MediaStore: $uriString")
                    result.error("FILE_NOT_FOUND", "File not found in MediaStore. It may have been already deleted.", null)
                    return
                }
                cursor.close()

                val uris = listOf(uri)
                val pi = MediaStore.createDeleteRequest(contentResolver, uris)
                deleteResult = result
                startIntentSenderForResult(pi.intentSender, DELETE_REQUEST_CODE, null, 0, 0, 0)
            } catch (e: SecurityException) {
                Log.e(TAG, "SecurityException during delete request", e)
                result.error("PERMISSION_DENIED", "Permission denied: ${e.message}", null)
            } catch (e: Exception) {
                Log.e(TAG, "Exception during delete request", e)
                result.error("DELETE_FAILED", "Failed to create delete request: ${e.message}", null)
            }
            return
        }

        // For Android Q (10), try direct delete first, then handle RecoverableSecurityException
        try {
            val rowsDeleted = contentResolver.delete(uri, null, null)
            Log.d(TAG, "contentResolver.delete returned: $rowsDeleted rows")
            if (rowsDeleted > 0) {
                result.success(true)
            } else {
                Log.e(TAG, "No rows deleted - file may not exist or we don't have permission")
                result.error("FILE_NOT_FOUND", "File not found or already deleted", null)
            }
        } catch (e: SecurityException) {
            Log.d(TAG, "SecurityException caught, checking for RecoverableSecurityException", e)
            // On Android 10 (Q), RecoverableSecurityException might be thrown if not owner
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val recoverableSecurityException = e as? android.app.RecoverableSecurityException
                if (recoverableSecurityException != null) {
                    Log.d(TAG, "RecoverableSecurityException - launching user action")
                    deleteResult = result
                    try {
                        startIntentSenderForResult(
                            recoverableSecurityException.userAction.actionIntent.intentSender,
                            DELETE_REQUEST_CODE,
                            null,
                            0,
                            0,
                            0
                        )
                    } catch (sendEx: Exception) {
                        Log.e(TAG, "Failed to start intent sender", sendEx)
                        result.error("PERMISSION_DENIED", "Failed to request permission: ${sendEx.message}", null)
                        deleteResult = null
                    }
                    return
                }
            }
            Log.e(TAG, "Non-recoverable SecurityException", e)
            result.error("PERMISSION_DENIED", "Permission denied: ${e.message}", null)
        } catch (e: Exception) {
            Log.e(TAG, "Exception during delete", e)
            result.error("DELETE_FAILED", "Deletion failed: ${e.message}", null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        Log.d(TAG, "onActivityResult: requestCode=$requestCode, resultCode=$resultCode")
        if (requestCode == DELETE_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                Log.d(TAG, "User approved deletion")
                deleteResult?.success(true)
            } else {
                Log.d(TAG, "User cancelled or denied deletion")
                deleteResult?.error("USER_CANCELLED", "User cancelled the deletion", null)
            }
            deleteResult = null
        }
    }
}

