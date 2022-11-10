package com.voxeet.sdk.services;

import android.net.Uri;
import android.util.Pair;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.voxeet.VoxeetSDK;
import com.voxeet.promise.Promise;
import com.voxeet.sdk.json.FilePresentationStarted;
import com.voxeet.sdk.models.v1.FilePresentationConverted;
import com.voxeet.sdk.services.presentation.file.FilePresentation;

import org.greenrobot.eventbus.EventBus;

import java.io.File;
import java.net.URL;

public class FilePresentationService {
    public boolean convertHasRun = false;
    public File convertArgs;
    public boolean updateHasRun;
    public Pair<String, Integer> updateArgs;
    public boolean startHasRun;
    public FilePresentationConverted startArgs;
    public boolean stopHasRun;
    public URL imageReturn;
    public URL thumbnailReturn;
    public boolean imageHasRun;
    public boolean thumbnailHasRun;
    public Pair<String, Integer> imageArgs;
    public Pair<String, Integer> thumbnailArgs;

    @NonNull
    public Promise<FilePresentation> convert(@NonNull final File file) {
        convertHasRun = true;
        convertArgs = file;
        FilePresentation filePresentation = new FilePresentation("file-1", file.toURI().toString());
        FilePresentationStarted filePresentationStarted = new FilePresentationStarted();
        filePresentationStarted.conferenceId = VoxeetSDK.conference().getConferenceId();
        filePresentationStarted.userId = VoxeetSDK.session().getParticipantId();
        filePresentationStarted.fileId = filePresentation.key;
        EventBus.getDefault().post(filePresentationStarted);
        return Promise.resolve(filePresentation);
    }

    @Nullable
    public String image(String fileId, int pageNumber) {
        imageHasRun = true;
        imageArgs = new Pair<>(fileId, pageNumber);
        return imageReturn.toString();
    }

    @Nullable
    public String thumbnail(String fileId, int pageNumber) {
        thumbnailHasRun = true;
        thumbnailArgs = new Pair<>(fileId, pageNumber);
        return thumbnailReturn.toString();
    }

    @NonNull
    public Promise<FilePresentation> update(@NonNull final String fileId,
                                            final int position) {
        updateHasRun = true;
        updateArgs = new Pair<>(fileId, position);
        return Promise.resolve(new FilePresentation(fileId, String.format("url://file-%s/page/%s", fileId, position)));
    }

    @NonNull
    public Promise<FilePresentation> stop(@NonNull final String fileId) {
        stopHasRun = true;
        return Promise.resolve(new FilePresentation(fileId, String.format("url://file-%s", fileId)));
    }

    @NonNull
    public Promise<FilePresentation> start(@NonNull final FilePresentationConverted body) {
        startHasRun = true;
        startArgs = body;
        return start(body, 0);
    }

    @NonNull
    public Promise<FilePresentation> start(@NonNull final FilePresentationConverted body,
                                           final int position) {
        android.util.Log.d("[KB]", "start method with args: " + body);
        FilePresentationStarted filePresentationStarted = new FilePresentationStarted();
        filePresentationStarted.conferenceId = VoxeetSDK.conference().getConferenceId();
        filePresentationStarted.userId = VoxeetSDK.session().getParticipantId();
        filePresentationStarted.fileId = body.fileId;
        android.util.Log.d("[KB]", "start method send event: " + filePresentationStarted);
        EventBus.getDefault().post(filePresentationStarted);
        return Promise.resolve(new FilePresentation(body.fileId, String.format("url://file-%s/page/%s", body.fileId, position)));
    }
}
