package com.voxeet.sdk.services.presentation.file;

import androidx.annotation.NonNull;

import com.voxeet.sdk.services.presentation.PresentationState;

public class FilePresentation {

    public final String key;

    public final String url;

    /**
     * The current state of the presentation.
     */
    public PresentationState state;

    /**
     * The currently displayed page.
     */
    public int page;

    /**
     * The number of pages inside the corresponding FilePresentation instance.
     */
    public int nbPage;

    private FilePresentation() {
        key = "";
        url = "";
        page = 0;
    }

    public FilePresentation(@NonNull String key, @NonNull String url) {
        this.key = key;
        this.url = url;
        page = 0;
    }

    public FilePresentation clone() {
        FilePresentation information = new FilePresentation(key, url);
        information.state = state;
        return information;
    }
}

