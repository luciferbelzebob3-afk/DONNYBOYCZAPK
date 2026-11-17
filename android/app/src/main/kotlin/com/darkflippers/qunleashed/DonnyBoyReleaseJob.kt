package com.darkflippers.qunleashed

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.job.JobInfo
import android.app.job.JobParameters
import android.app.job.JobScheduler
import android.app.job.JobService
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import kotlin.concurrent.thread

/** Opt-in periodic checks of public releases. No cloud notification service. */
class DonnyBoyReleaseJob : JobService() {
    @Volatile private var stopped = false
    @Volatile private var connection: HttpURLConnection? = null

    override fun onStartJob(params: JobParameters): Boolean {
        stopped = false
        thread(name = "DonnyBoyReleaseCheck") {
            var retry = false
            try {
                checkRelease()
            } catch (_: Exception) {
                retry = true
            } finally {
                connection?.disconnect()
                connection = null
                Handler(Looper.getMainLooper()).post {
                    if (!stopped) jobFinished(params, retry)
                }
            }
        }
        return true
    }

    override fun onStopJob(params: JobParameters): Boolean {
        stopped = true
        connection?.disconnect()
        return true
    }

    private fun checkRelease() {
        val prefs = getSharedPreferences("donnyboy_releases", Context.MODE_PRIVATE)
        val http = URL(API).openConnection() as HttpURLConnection
        connection = http
        http.connectTimeout = 15000
        http.readTimeout = 15000
        http.setRequestProperty("Accept", "application/vnd.github+json")
        http.setRequestProperty("User-Agent", "DonnyBoy-Android")
        prefs.getString("etag", null)?.let { http.setRequestProperty("If-None-Match", it) }
        val status = http.responseCode
        if (status == 304 || stopped) return
        check(status == 200) { "GitHub HTTP $status" }
        val release = JSONObject(http.inputStream.bufferedReader().use { it.readText() })
        if (stopped) return
        val tag = release.getString("tag_name")
        val page = release.getString("html_url")
        check(page.startsWith(RELEASES)) { "Unexpected release URL" }
        val previous = prefs.getString("last_tag", null)
        if (previous != null && previous != tag && !notifyRelease(tag, page)) return
        prefs.edit().putString("last_tag", tag)
            .putString("etag", http.getHeaderField("ETag")).apply()
    }

    private fun notifyRelease(tag: String, page: String): Boolean {
        if (Build.VERSION.SDK_INT >= 33 &&
            checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
            return false
        }
        val manager = getSystemService(NotificationManager::class.java)
        if (!manager.areNotificationsEnabled()) return false
        manager.createNotificationChannel(
            NotificationChannel(CHANNEL, "Nové verze DONNY BOY CZ", NotificationManager.IMPORTANCE_DEFAULT),
        )
        if (manager.getNotificationChannel(CHANNEL).importance == NotificationManager.IMPORTANCE_NONE) return false
        val pending = PendingIntent.getActivity(
            this, 1905, Intent(Intent.ACTION_VIEW, Uri.parse(page)),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        manager.notify(1905, Notification.Builder(this, CHANNEL)
            .setSmallIcon(android.R.drawable.stat_sys_download_done)
            .setContentTitle("Nová verze DONNY BOY CZ")
            .setContentText(tag)
            .setContentIntent(pending)
            .setAutoCancel(true).build())
        return true
    }

    companion object {
        private const val JOB_ID = 1905
        private const val CHANNEL = "donnyboy_releases"
        private const val API = "https://api.github.com/repos/luciferbelzebob3-afk/DONNYBOYCZ/releases/latest"
        private const val RELEASES = "https://github.com/luciferbelzebob3-afk/DONNYBOYCZ/releases/"

        fun enable(context: Context): Boolean {
            val job = JobInfo.Builder(JOB_ID, ComponentName(context, DonnyBoyReleaseJob::class.java))
                .setRequiredNetworkType(JobInfo.NETWORK_TYPE_ANY)
                .setPeriodic(15 * 60 * 1000L)
                .setPersisted(true)
                .build()
            return context.getSystemService(JobScheduler::class.java).schedule(job) == JobScheduler.RESULT_SUCCESS
        }

        fun disable(context: Context) {
            context.getSystemService(JobScheduler::class.java).cancel(JOB_ID)
        }
    }
}
