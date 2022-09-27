package com.voxeet.sdk.views;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;

import androidx.annotation.Nullable;

import com.voxeet.android.media.MediaStream;

import org.jetbrains.annotations.NotNull;

public class VideoView extends View {
    private Paint paint = new Paint();
    @Nullable
    private String peerId = null;
    @Nullable
    private MediaStream stream = null;

    public VideoView(Context context) {
        super(context);
    }

    public VideoView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
    }

    public VideoView(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public VideoView(Context context, @Nullable AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        paint.setColor(Color.RED);
        paint.setStrokeWidth(5);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        canvas.drawLine(0, 0, 100, 100, paint);

    }

    public void unAttach() {

    }

    public boolean isAttached() {
        return peerId != null && stream != null;
    }

    public boolean isScreenShare() {
        return true;
    }

    public void attach(@NotNull String participantId, @NotNull MediaStream mediaStream) {
        this.peerId = participantId;
        this.stream = mediaStream;
    }
}
