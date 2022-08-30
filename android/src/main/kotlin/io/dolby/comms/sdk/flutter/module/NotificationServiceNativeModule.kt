package io.dolby.comms.sdk.flutter.module

import com.voxeet.VoxeetSDK
import io.dolby.comms.sdk.flutter.extension.argumentOrThrow
import io.dolby.comms.sdk.flutter.extension.await
import io.dolby.comms.sdk.flutter.extension.error
import io.dolby.comms.sdk.flutter.extension.launch
import io.dolby.comms.sdk.flutter.mapper.ParticipantInvitedMapper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope

class NotificationServiceNativeModule(private val scope: CoroutineScope) : NativeModule {
    private lateinit var channel: MethodChannel

    override fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dolbyio_notification_service_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onDetached() {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            ::invite.name -> invite(call, result)
            ::decline.name -> decline(call, result)
        }
    }

    private fun invite(call: MethodCall, result: MethodChannel.Result) = scope.launch(
        onError = result::error,
        onSuccess = {
            val conferenceId = call.argumentOrThrow<Map<String, Any?>>("conference")["id"] as String
            val participants = call
                .argumentOrThrow<List<Map<String, Any?>>>("participants")
                .map { ParticipantInvitedMapper.fromMap(it) }
                .toMutableList()

            val conference = VoxeetSDK.conference().getConference(conferenceId)

            VoxeetSDK
                .notification()
                .inviteWithPermissions(conference, participants)
                .await()
                .also { result.success(null) }
        }
    )

    private fun decline(call: MethodCall, result: MethodChannel.Result) = scope.launch(
        onError = result::error,
        onSuccess = {
            val conferenceId = call.argumentOrThrow<Map<String, Any?>>("conference")["id"] as String
            val conference = VoxeetSDK.conference().getConference(conferenceId)

            VoxeetSDK
                .notification()
                .decline(conference)
                .await()
                .also { result.success(null) }
        }
    )
}
