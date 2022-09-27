package com.voxeet.sdk.services;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.voxeet.promise.Promise;
import com.voxeet.sdk.models.v1.FilePresentationConverted;
import com.voxeet.sdk.services.presentation.file.FilePresentation;

import org.jetbrains.annotations.NotNull;

import java.io.File;
import java.util.Locale;

public class FilePresentationService {
    @NonNull
    public Promise<FilePresentation> convert(@NonNull final File file) {
        return Promise.resolve(new FilePresentation("file-1", file.toURI().toString()));
    }

    @Nullable
    public String image(String fileId, int pageNumber) {
        return String.format("image:%s, page:%s", fileId, pageNumber);
    }

    @Nullable
    public String thumbnail(String fileId, int pageNumber) {
        return String.format("thumbnail:%s, page:%s", fileId, pageNumber);
    }

    @NonNull
    public Promise<FilePresentation> update(@NonNull final String fileId,
                                            final int position) {
        return Promise.resolve(new FilePresentation(fileId, String.format("url://file-%s/page/%s", fileId, position)));
    }

    @NonNull
    public Promise<FilePresentation> stop(@NonNull final String fileId) {
        return Promise.resolve(new FilePresentation(fileId, String.format("url://file-%s", fileId)));
    }

    @NonNull
    public Promise<FilePresentation> start(@NonNull final FilePresentationConverted body) {
        return start(body, 0);
    }

    @NonNull
    public Promise<FilePresentation> start(@NonNull final FilePresentationConverted body,
                                           final int position) {
        return Promise.resolve(new FilePresentation(body.fileId, String.format("url://file-%s/page/%s", body.fileId, position)));
    }
}
