package io.dolby.comms.sdk.flutter.module

import android.content.res.Resources.NotFoundException
import com.voxeet.VoxeetSDK
import io.dolby.comms.sdk.flutter.extension.*
import io.dolby.comms.sdk.flutter.mapper.ParticipantInvitedMapper
import io.dolby.comms.sdk.flutter.mapper.SubscriptionMapper
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
            ::subscribe.name -> subscribe(call, result)
            ::unsubscribe.name -> unsubscribe(call, result)
            else -> result.error(NotFoundException("Method: ${call.method} not found on native module"))
        }
    }

    private fun invite(call: MethodCall, result: MethodChannel.Result) = scope.launch(
        onError = result::onError,
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
        onError = result::onError,
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

    private fun subscribe(call: MethodCall, result: MethodChannel.Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val subscriptions = call.argumentOrThrow<List<Map<String, Any?>>>("subscriptions")
                .map { m ->
                    SubscriptionMapper.fromMap(m)
                }
                .filterNotNull()
            VoxeetSDK
                .notification()
                .subscribe(subscriptions)
                .await()
                .also { r -> if(r) result.success(null) else result.onError(java.lang.Exception("Cannot subscribe to given subscriptions")) }

        }
    )

    private fun unsubscribe(call: MethodCall, result: MethodChannel.Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val subscriptions = call.argumentOrThrow<List<Map<String, Any?>>>("subscriptions")
                .map { m ->
                    SubscriptionMapper.fromMap(m)
                }
                .filterNotNull()
            VoxeetSDK.notification()
                .unsubscribe(subscriptions)
                .await()
                .also { r -> if(r) result.success(null) else result.onError(java.lang.Exception("Cannot unsubscribe for given subscriptions"))  }
        }
    )
}
