package io.dolby.comms.sdk.flutter

import androidx.annotation.NonNull
import com.voxeet.VoxeetSDK
import io.dolby.comms.sdk.flutter.dolbyio_comms_sdk_flutter.BuildConfig
import io.dolby.comms.sdk.flutter.events.*
import io.dolby.comms.sdk.flutter.module.CommandServiceNativeModule
import io.dolby.comms.sdk.flutter.module.CommsSdkNativeModule
import io.dolby.comms.sdk.flutter.module.ConferenceServiceNativeModule
import io.dolby.comms.sdk.flutter.module.FilePresentationServiceModule
import io.dolby.comms.sdk.flutter.module.MediaDeviceServiceNativeModule
import io.dolby.comms.sdk.flutter.module.NativeModule
import io.dolby.comms.sdk.flutter.module.NotificationServiceNativeModule
import io.dolby.comms.sdk.flutter.module.RecordingServiceNativeModule
import io.dolby.comms.sdk.flutter.module.SessionServiceNativeModule
import io.dolby.comms.sdk.flutter.module.VideoPresentationServiceModule
import io.dolby.comms.sdk.flutter.module.audio.AudioPreviewNativeModule
import io.dolby.comms.sdk.flutter.module.audio.LocalAudioNativeModule
import io.dolby.comms.sdk.flutter.module.audio.RemoteAudioNativeModule
import io.dolby.comms.sdk.flutter.module.video.LocalVideoNativeModule
import io.dolby.comms.sdk.flutter.module.video.RemoteVideoNativeModule
import io.dolby.comms.sdk.flutter.screenshare.ScreenShareHandler
import io.dolby.comms.sdk.flutter.state.FilePresentationHolder
import io.dolby.comms.sdk.flutter.state.VideoPresentationHolder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancelChildren
import org.webrtc.CodecDescriptorFactory

class DolbyioCommsSdkFlutterPlugin : FlutterPlugin, ActivityAware {

    private val scope: CoroutineScope = CoroutineScope(SupervisorJob())
    private val screenShareHandler = ScreenShareHandler()

    private lateinit var nativeModules: List<NativeModule>
    private lateinit var nativeEventEmitters: List<NativeEventEmitter>
    private lateinit var videoViewFactory: NativeViewFactory

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val videoPresentationHolder = VideoPresentationHolder()
        val filePresentationHolder = FilePresentationHolder()
        val filePresentationEventEmitter = FilePresentationEventEmitter(EventChannelHandler(FILE_PRESENTATION), filePresentationHolder)

        nativeEventEmitters = listOf(
            CommandEventEmitter(EventChannelHandler(COMMAND)),
            ConferenceEventEmitter(EventChannelHandler(CONFERENCE)),
            NotificationEventEmitter(EventChannelHandler(NOTIFICATION)),
            RecordingEventEmitter(EventChannelHandler(RECORDING)),
            VideoPresentationEventEmitter(EventChannelHandler(VIDEO_PRESENTATION), videoPresentationHolder),
            filePresentationEventEmitter,
            AudioPreviewEventEmitter(EventChannelHandler(AUDIO_PREVIEW))
        )

        nativeModules = listOf(
            LocalAudioNativeModule(scope),
            RemoteAudioNativeModule(scope),
            LocalVideoNativeModule(scope),
            RemoteVideoNativeModule(scope),
            CommandServiceNativeModule(scope),
            NotificationServiceNativeModule(scope),
            CommsSdkNativeModule(scope),
            ConferenceServiceNativeModule(scope),
            SessionServiceNativeModule(scope),
            RecordingServiceNativeModule(scope),
            VideoPresentationServiceModule(scope, videoPresentationHolder),
            FilePresentationServiceModule(
                flutterPluginBinding.applicationContext,
                scope,
                filePresentationEventEmitter,
                filePresentationHolder
            ),
            MediaDeviceServiceNativeModule(scope),
            AudioPreviewNativeModule(scope)
        )

        VoxeetSDK.registerComponentVersion(BuildConfig.COMPONENT_NAME, BuildConfig.SDK_VERSION)

        nativeModules.forEach { it.onAttached(flutterPluginBinding) }
        nativeEventEmitters.forEach { it.onAttached(flutterPluginBinding) }
        videoViewFactory = NativeViewFactory(flutterPluginBinding.binaryMessenger)

        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory("video_view", videoViewFactory)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        nativeModules.forEach { it.onDetached() }
        nativeEventEmitters.forEach { it.onDetached() }
        scope.coroutineContext.cancelChildren(null)
    }

    private companion object EventChannel {
        const val COMMAND = "dolbyio_command_service_event_channel"
        const val CONFERENCE = "dolbyio_conference_service_event_channel"
        const val NOTIFICATION = "dolbyio_notification_service_event_channel"
        const val RECORDING = "dolbyio_recording_service_event_channel"
        const val VIDEO_PRESENTATION = "dolbyio_video_presentation_service_event_channel"
        const val FILE_PRESENTATION = "dolbyio_file_presentation_service_event_channel"
        const val AUDIO_PREVIEW = "dolbyio_audio_preview_event_channel"
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        screenShareHandler.activity = binding.activity
        binding.addActivityResultListener(screenShareHandler)
        FlutterLifecycleAdapter.getActivityLifecycle(binding).addObserver(screenShareHandler)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        screenShareHandler.activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        screenShareHandler.activity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        screenShareHandler.activity = null
    }
}
