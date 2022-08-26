package io.dolby.comms.sdk.flutter

import androidx.annotation.NonNull
import io.dolby.comms.sdk.flutter.events.CommandEventEmitter
import io.dolby.comms.sdk.flutter.events.ConferenceEventEmitter
import io.dolby.comms.sdk.flutter.events.EventChannelHandler
import io.dolby.comms.sdk.flutter.events.FilePresentationEventEmitter
import io.dolby.comms.sdk.flutter.events.NativeEventEmitter
import io.dolby.comms.sdk.flutter.events.NotificationEventEmitter
import io.dolby.comms.sdk.flutter.events.VideoPresentationEventEmitter
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
import io.dolby.comms.sdk.flutter.state.FilePresentationHolder
import io.dolby.comms.sdk.flutter.state.VideoPresentationHolder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob

class DolbyioCommsSdkFlutterPlugin : FlutterPlugin {

    private val scope: CoroutineScope = CoroutineScope(SupervisorJob())

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
            VideoPresentationEventEmitter(EventChannelHandler(VIDEO_PRESENTATION), videoPresentationHolder),
            filePresentationEventEmitter
        )

        nativeModules = listOf(
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
            MediaDeviceServiceNativeModule(scope)
        )

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
    }

    private companion object EventChannel {
        const val COMMAND = "dolbyio_command_service_event_channel"
        const val CONFERENCE = "dolbyio_conference_service_event_channel"
        const val NOTIFICATION = "dolbyio_notification_service_event_channel"
        const val VIDEO_PRESENTATION = "dolbyio_video_presentation_service_event_channel"
        const val FILE_PRESENTATION = "dolbyio_file_presentation_service_event_channel"
    }
}
