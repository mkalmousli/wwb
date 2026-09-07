package com.github.mkalmousli.wwb

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Bridges incoming links to Flutter so they open the Link screen directly:
 *  - a URL shared into the app (ACTION_SEND, text/plain)
 *  - a `wwb://open?url=...` (or `wwb://<url>`) deep link (ACTION_VIEW)
 */
class MainActivity : FlutterActivity() {
    private val channelName = "wwb/links"
    private var channel: MethodChannel? = null
    private var pendingLink: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
        channel?.setMethodCallHandler { call, result ->
            if (call.method == "getInitialLink") {
                result.success(pendingLink)
                pendingLink = null
            } else {
                result.notImplemented()
            }
        }
        extractLink(intent)?.let { pendingLink = it }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val link = extractLink(intent) ?: return
        val ch = channel
        if (ch != null) ch.invokeMethod("link", link) else pendingLink = link
    }

    private fun extractLink(intent: Intent?): String? {
        intent ?: return null
        return when (intent.action) {
            Intent.ACTION_SEND ->
                intent.getStringExtra(Intent.EXTRA_TEXT)?.let(::firstUrl)
            Intent.ACTION_VIEW -> {
                val data = intent.data ?: return null
                data.getQueryParameter("url")
                    ?: data.schemeSpecificPart?.trim()?.trimStart('/')
            }
            else -> null
        }
    }

    private fun firstUrl(text: String): String? {
        val m = Regex("""https?://\S+""").find(text)
        if (m != null) return m.value
        val t = text.trim()
        return if (t.contains('.') && !t.contains(' ')) t else null
    }
}
