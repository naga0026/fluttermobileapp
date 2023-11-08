package com.tjxsbostoreapp
import android.Manifest
import android.content.*
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.multidex.MultiDex
import com.tjxsbostoreapp.logging.LogHelper
import com.tjxsbostoreapp.printing.PrintHelper
import com.tjxsbostoreapp.scanning.DWInterface
import com.tjxsbostoreapp.scanning.Scan
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONObject
import java.io.File
import java.text.SimpleDateFormat
import java.util.*

class MainActivity: FlutterActivity() {

    //region Variables & Constants
    private val SCAN_CHANNEL = "com.tjxsbostoreapp/scan"
    private val COMMAND_CHANNEL = "com.tjxsbostoreapp/sbo_print_method_channel"
    private val OPEN_LOG_FILE = "com.tjxsbostoreapp/sbo_log_channel"
    private val RESTART_APP = "com.tjxsbostoreapp/sbo_restart_channel"
    private val LOAD_COFIG = "com.tjxsbostoreapp/sbo_config_channel"
    val PROFILE_INTENT_ACTION = "com.tjxsbostoreapp.SCAN"

    private val PERMISSION_R_CODE = 7

//    private val scanHelper = ScanHelper(context)
    private val dwInterface = DWInterface()
    private val PROFILE_INTENT_BROADCAST = "2"
    private val printerHelper = PrintHelper()
    private val logHelper = LogHelper(context)
    var folderName: String? = null

    //endregion

    //region On Create
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MultiDex.install(this);
    }
    //endregion

    //region Configure flutter engine
    @RequiresApi(Build.VERSION_CODES.Q)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        //region Event channel
        EventChannel(flutterEngine.dartExecutor, SCAN_CHANNEL).setStreamHandler(
                object : EventChannel.StreamHandler {
                    private var dataWedgeBroadcastReceiver: BroadcastReceiver? = null
                    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                        dataWedgeBroadcastReceiver = createDataWedgeBroadcastReceiver(events)
                        val intentFilter = IntentFilter()
                        intentFilter.addAction(PROFILE_INTENT_ACTION)
                        registerReceiver(
                                dataWedgeBroadcastReceiver, intentFilter)
                    }

                    override fun onCancel(arguments: Any?) {
                        unregisterReceiver(dataWedgeBroadcastReceiver)
                        dataWedgeBroadcastReceiver = null
                    }
                }
        )
        //endregion

        //region Method channel
        MethodChannel(flutterEngine.dartExecutor, COMMAND_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendDataWedgeCommandStringParameter") {
                val arguments = JSONObject(call.arguments.toString())
                val command: String = arguments.get("command") as String
                val parameter: String = arguments.get("parameter") as String
                sendCommandString(applicationContext, command, parameter)
            } else if (call.method == "createDataWedgeProfile") {
                createDataWedgeProfile(call.arguments.toString())
            } else if (call.method == "enableDataWedge") {
                enableDataWedge()
            } else if (call.method == "disableDataWedge") {
                disableDataWedge()
            } else if (call.method == "connectToPrinterWithIP") {
                val arguments = JSONObject(call.arguments.toString())
                val ip: String = arguments.get("printerId") as String
                val port = 9100
                printerHelper.connectPrinterWithIP(ip, port, result)
                //result.success(isConnected)
            } else if (call.method == "printLabel") {
                val arguments = JSONObject(call.arguments.toString())
                val ip: String = arguments.get("printerId") as String
                val labelDef: String = arguments.get("label") as String
                val printer = printerHelper.findPrinterFromIP(ip)
                if(printer != null){
                    printerHelper.printLabelFromZebraPrinter(labelDef, result, printer)
                }
            } else if (call.method == "disconnect") {
                val arguments = JSONObject(call.arguments.toString())
                val ip: String = arguments.get("printerId") as String
                val printer = printerHelper.findPrinterFromIP(ip)
                if(printer != null){
                    val res = printerHelper.disconnect(printer.connection, result, printer)
                }
            } else if (call.method == "isPrinterAvailable") {
                val arguments = JSONObject(call.arguments.toString())
                val ip: String = arguments.get("printerId") as String
            } else if (call.method == "calibrate_printer"){
                val arguments = JSONObject(call.arguments.toString())
                val ip: String = arguments.get("printerIp") as String
                val commandToPass: String = arguments.get("command") as String
                printerHelper.writeToConnection(ip, commandToPass)
            }
            else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor, OPEN_LOG_FILE).setMethodCallHandler { call, result ->

            if (call.method == "open_log_file") {
                if (call.hasArgument("filepath")) {
                    val filepath = call.argument<String>("filepath")
                    if (filepath != null) {
                        logHelper.openLogFile(filepath)
                    }
                }
            }
        }
        MethodChannel(flutterEngine.dartExecutor, RESTART_APP).setMethodCallHandler { call, result ->
            if (call.method == "restart") {
                restartApp()
                result.success(true)
            }else{
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor, LOAD_COFIG).setMethodCallHandler { call, result ->

            if (call.method == "load_config") {
                try {
                    val arg = JSONObject(call.arguments.toString())
                    folderName = arg.get("FolderName").toString()
                    if (Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS + File.separator + folderName)
                                    .deleteRecursively() && folderName != null
                    ) {
                        arg.remove("FolderName")
                        arg.keys().forEach { key ->
                            saveFileToFolder(key, arg.get(key).toString().toByteArray())

                        }
                    }

                    Toast.makeText(this, "Configuration Loaded(Folder)", Toast.LENGTH_SHORT).show()
                    result.success(true)
                } catch (e: Exception) {
                    Toast.makeText(this, "Configuration Failed(Folder):$e", Toast.LENGTH_SHORT).show()
                    result.notImplemented()
                }
            } else if (call.method == "load_single_config") {
                try {
                    val arg = JSONObject(call.arguments.toString())
                    folderName = arg.get("FolderName").toString()
                    arg.remove("FolderName")
                    arg.keys().forEach { key ->
                        saveFileToFolder(key, arg.get(key).toString().toByteArray())

                    }

                    Toast.makeText(this, "Configuration Loaded(File)", Toast.LENGTH_SHORT).show()
                    result.success(true)
                } catch (e: Exception) {
                    Toast.makeText(this, "Configuration Failed(File) :$e", Toast.LENGTH_SHORT).show()
                    result.notImplemented()
                }
            }else if (call.method == "rewrite_file") {
                try {
                    val arg = JSONObject(call.arguments.toString())
                    folderName = arg.get("FolderName").toString()
                    arg.remove("FolderName")
                    val documentsDirectory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS+ File.separator + folderName)
                    arg.keys().forEach { key ->
                        if(File(documentsDirectory,key).deleteRecursively()){
                            saveFileToFolder(key, arg.get(key).toString().toByteArray())
                        }

                    }

                    Toast.makeText(this, "Ip-Address Updated", Toast.LENGTH_SHORT).show()
                    result.success(true)
                } catch (e: Exception) {
                    Toast.makeText(this, "Failed to Update Ip-Address:$e", Toast.LENGTH_SHORT).show()
                    result.notImplemented()
                }

            }


        }
        //endregion
    }

    private fun restartApp() {
        val  ctx:Context= applicationContext
        val pm:PackageManager = ctx.packageManager
        val intent:Intent? = pm.getLaunchIntentForPackage(ctx.packageName)
        val mainIntent = Intent.makeRestartActivityTask(intent?.component)
        startActivity(mainIntent)
        Runtime.getRuntime().exit(0)
    }
    //endregion

    @RequiresApi(Build.VERSION_CODES.Q)
    fun saveFileToFolder(fileName: String, data: ByteArray) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
            ActivityCompat.requestPermissions(
                    this, arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), PERMISSION_R_CODE
            )
        }
        val folder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            // For Android 11 and above, use MediaStore API
            val resolver = context.contentResolver
            val contentValues = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                put(MediaStore.MediaColumns.MIME_TYPE, "application/octet-stream")
                put(
                        MediaStore.MediaColumns.RELATIVE_PATH,
                        Environment.DIRECTORY_DOCUMENTS + File.separator + folderName
                )
            }
            resolver.insert(
                    MediaStore.Files.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY), contentValues
            )?.let {
                resolver.openOutputStream(it)
            }
        } else {
            // For older versions, use Environment.getExternalStorageDirectory()
            val folderPath =
                    Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS + File.separator + folderName)
            if (!folderPath.exists()) {
                folderPath.mkdirs()
            }
            File(folderPath, fileName).outputStream()
        }

        folder?.use { outputStream ->
            outputStream.write(data)
            outputStream.flush()
            outputStream.close()
        }
    }

    fun createDataWedgeBroadcastReceiver(events: EventChannel.EventSink?): BroadcastReceiver? {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (intent.action.equals(PROFILE_INTENT_ACTION)) {
                    //  A barcode has been scanned
                    val scanData = intent.getStringExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_DATA_STRING)
                    val symbology = intent.getStringExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_LABEL_TYPE)
                    val date = Calendar.getInstance().getTime()
                    val df = SimpleDateFormat("dd/MM/yyyy HH:mm:ss")
                    val dateTimeString = df.format(date)
                    val currentScan = Scan(scanData, symbology, dateTimeString);
                    events?.success(currentScan.toJson())
                }
                //  Could handle return values from DW here such as RETURN_GET_ACTIVE_PROFILE
                //  or RETURN_ENUMERATE_SCANNERS
            }
        }
    }


    //region Create profile
    private fun createDataWedgeProfile(profileName: String) {
        //  Create and configure the DataWedge profile associated with this application
        //  For readability's sake, I have not defined each of the keys in the DWInterface file
        sendCommandString(this, DWInterface.DATAWEDGE_SEND_CREATE_PROFILE, profileName)
        val profileConfig = Bundle()
        profileConfig.putString("PROFILE_NAME", profileName)
        profileConfig.putString("PROFILE_ENABLED", "true") //  These are all strings
        profileConfig.putString("CONFIG_MODE", "UPDATE")
        val barcodeConfig = Bundle()
        barcodeConfig.putString("PLUGIN_NAME", "BARCODE")
        barcodeConfig.putString("RESET_CONFIG", "true") //  This is the default but never hurts to specify
        val barcodeProps = Bundle()
        barcodeConfig.putBundle("PARAM_LIST", barcodeProps)
        profileConfig.putBundle("PLUGIN_CONFIG", barcodeConfig)
        val appConfig = Bundle()
        appConfig.putString("PACKAGE_NAME", packageName)      //  Associate the profile with this app
        appConfig.putStringArray("ACTIVITY_LIST", arrayOf("*"))
        profileConfig.putParcelableArray("APP_LIST", arrayOf(appConfig))
        sendCommandBundle(DWInterface.DATAWEDGE_SEND_SET_CONFIG, profileConfig)
        //  You can only configure one plugin at a time in some versions of DW, now do the intent output
        profileConfig.remove("PLUGIN_CONFIG")
        val intentConfig = Bundle()
        intentConfig.putString("PLUGIN_NAME", "INTENT")
        intentConfig.putString("RESET_CONFIG", "true")
        val intentProps = Bundle()
        intentProps.putString("intent_output_enabled", "true")
        intentProps.putString("intent_action", PROFILE_INTENT_ACTION)
        intentProps.putString("intent_delivery", PROFILE_INTENT_BROADCAST)  //  "2"
        intentConfig.putBundle("PARAM_LIST", intentProps)
        profileConfig.putBundle("PLUGIN_CONFIG", intentConfig)
        sendCommandBundle(DWInterface.DATAWEDGE_SEND_SET_CONFIG, profileConfig)
    }
    //endregion

    //region Scanning Functions

    private fun enableDataWedge() {
        val i = Intent()
        i.action = "com.symbol.datawedge.api.ACTION"
        i.putExtra("com.symbol.datawedge.api.SCANNER_INPUT_PLUGIN", "ENABLE_PLUGIN")
       // i.putExtra("com.symbol.datawedge.api.ENABLE_DATAWEDGE", true)
        context.sendBroadcast(i)
    }

    private fun disableDataWedge() {
        val i = Intent()
        i.action = "com.symbol.datawedge.api.ACTION"
        //i.putExtra("com.symbol.datawedge.api.ENABLE_DATAWEDGE", false)
        i.putExtra("com.symbol.datawedge.api.SCANNER_INPUT_PLUGIN", "DISABLE_PLUGIN")
        context.sendBroadcast(i)
    }

    //endregion

    //region Send Command
    private fun sendCommandString(
            applicationContext: Context?,
            command: String,
            parameter: String
    ) {
        val dwIntent = Intent()
        dwIntent.action = "com.symbol.datawedge.api.ACTION"
        dwIntent.putExtra(command, parameter)
        context.sendBroadcast(dwIntent)
    }


    private fun sendCommandBundle(command: String, parameter: Bundle) {
        val dwIntent = Intent()
        dwIntent.action = DWInterface.DATAWEDGE_SEND_ACTION
        dwIntent.putExtra(command, parameter)
        context.sendBroadcast(dwIntent)
    }
    //endregion


}
