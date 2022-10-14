package com.voxeet;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.voxeet.sdk.authent.token.RefreshTokenCallback;
import com.voxeet.sdk.services.AudioService;
import com.voxeet.sdk.services.CommandService;
import com.voxeet.sdk.services.ConferenceService;
import com.voxeet.sdk.services.FilePresentationService;
import com.voxeet.sdk.services.LocalStatsService;
import com.voxeet.sdk.services.MediaDeviceService;
import com.voxeet.sdk.services.NotificationService;
import com.voxeet.sdk.services.RecordingService;
import com.voxeet.sdk.services.ScreenShareService;
import com.voxeet.sdk.services.SessionService;
import com.voxeet.sdk.services.VideoPresentationService;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.EventBusException;
import org.jetbrains.annotations.NotNull;

public class VoxeetSDK {
    private final SessionService sessionService;
    private final ConferenceService conferenceService;
    private final CommandService commandService;
    private final MediaDeviceService mediaDeviceService;
    private final FilePresentationService filePresentationService;
    private final NotificationService notificationService;
    private final RecordingService recordingService;
    private final VideoPresentationService videoPresentationService;
    private final ScreenShareService screenShareService;
    private final LocalStatsService localStatsService;
    private final AudioService audioService;

    private static final VoxeetSDK currentInstance = new VoxeetSDK();


    @Deprecated
    public static void initialize(@NotNull String appKey, @NotNull String secretKey) {
    }

    public static void initialize(
            @NotNull String accessToken,
            @NotNull RefreshTokenCallback callback
    ) {

    }

    @NotNull
    public static AudioService audio() {
        return instance().audioService;
    }

    @NotNull
    public static SessionService session() {
        return instance().sessionService;
    }

    @NotNull
    public static ConferenceService conference() {
        return instance().conferenceService;
    }

    @NotNull
    public static ScreenShareService screenShare() {
        return instance().screenShareService;
    }

    @NotNull
    public static CommandService command() {
        return instance().commandService;
    }

    @NotNull
    public static FilePresentationService filePresentation() {
        return instance().filePresentationService;
    }

    @NotNull
    public static MediaDeviceService mediaDevice() {
        return instance().mediaDeviceService;
    }

    @NotNull
    public static NotificationService notification() {
        return instance().notificationService;
    }

    @NotNull
    public static RecordingService recording() {
        return instance().recordingService;
    }

    @NotNull
    public static VideoPresentationService videoPresentation() {
        return instance().videoPresentationService;
    }

    public static LocalStatsService localStats() {
        return instance().localStatsService;
    }

    private VoxeetSDK() {
        sessionService = new SessionService();
        conferenceService = new ConferenceService();
        commandService = new CommandService();
        filePresentationService = new FilePresentationService();
        mediaDeviceService = new MediaDeviceService();
        notificationService = new NotificationService();
        recordingService = new RecordingService();
        videoPresentationService = new VideoPresentationService();
        screenShareService = new ScreenShareService();
        localStatsService = new LocalStatsService();
        audioService = new AudioService();
    }

    @NotNull
    public static VoxeetSDK instance() {
        return currentInstance;
    }

    public boolean register(@Nullable Object subscriber) {
        try {
            EventBus eventBus = EventBus.getDefault();

            if (null != subscriber && !eventBus.isRegistered(subscriber))
                eventBus.register(subscriber);
        } catch (EventBusException error) {
            error.printStackTrace();
            return false;
        }

        return true;
    }
    public void unregister(@NonNull Object subscriber) {
        try {
            EventBus eventBus = EventBus.getDefault();
            if (eventBus.isRegistered(subscriber))
                eventBus.unregister(subscriber);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
