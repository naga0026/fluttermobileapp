package com.tjxsbostoreapp.logging
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.widget.Toast
import androidx.core.content.FileProvider
import com.tjxsbostoreapp.BuildConfig
import java.io.File

class LogHelper(private val context: Context) {

    fun openLogFile(filepath: String) {

        try {
            val filedata = FileProvider
                    .getUriForFile(context, BuildConfig.APPLICATION_ID + ".provider", File(filepath))
            val intent = Intent(Intent.ACTION_VIEW).apply {
                setDataAndType(filedata, "text/html")
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            val choose = Intent.createChooser(intent, "Open with")
            context.startActivity(choose)
        } catch (e: ActivityNotFoundException) {
            Toast.makeText(context, "Activity not found!", Toast.LENGTH_SHORT).show()
        }

    }
}