# dolby voice
-keep class com.dolby.voice.** { *; }
-keep interface com.dolby.voice.** { *; }

# flutter sdk
-keep class io.dolby.comms.sdk.flutter.** { *; }
-keep interface io.dolby.comms.sdk.flutter.** { *; }

# fasterxml
-keep class com.fasterxml.jackson.databind.ext.DOMSerializer { *; }
-keep class com.fasterxml.jackson.databind.introspect.JacksonAnnotationIntrospector$* { *; }
-keep class com.fasterxml.jackson.** { *; }
-keep interface com.fasterxml.jackson.** { *; }
# keep greenrobot > eventbus
-keep class org.greenrobot.** { *; }
-keep interface org.greenrobot.** { *; }
# keep for websockets
-keep class com.neovisionaries.ws.** { *; }
-keep class com.android.org.conscrypt.SSLParametersImpl { *; }
-keep class okhttp3.internal.platform.** { *; }

# don't warn
-dontwarn com.fasterxml.jackson.**
-dontwarn okhttp3.internal.platform.AndroidPlatform
-dontwarn com.squareup.picasso.Utils
-dontwarn retrofit2.Platform
-dontwarn retrofit2.Platform$IOS$MainThreadExecutor

# keep webrtc
-keep class org.webrtc.** { *; }
-keep interface org.webrtc.** { *; }
-keep class com.voxeet.** { *; }
-keep interface com.voxeet.** { *; }
-keep class voxeet.com.** { *; }
-keep interface voxeet.com.** { *; }
-keep class sdk.voxeet.** { *; }
-keep interface sdk.voxeet.** { *; }


-keep public class com.google.common.base.** {
 public *;
}

-keep public class com.google.common.collect.Sets
-keepclassmembers class com.google.common.collect.Sets** {
 *;
}

-keep public class com.google.common.collect.Collections2
-keepclassmembers class com.google.common.collect.Collections2** {
 *;
}

-keep public final class com.google.common.collect.Lists
-keepclassmembers class com.google.common.collect.Lists** {
 *;
}

-keep public final class com.google.common.collect.Iterables
-keepclassmembers class com.google.common.collect.Iterables** {
 *;
}

-keep public class com.google.common.collect.ImmutableList.** {
 public *;
}

-keep public class com.google.common.io.CharStreams {
 public *;
}

-keep public class com.google.common.collect.HashMultiset
-keepclassmembers class com.google.common.collect.HashMultiset** {
 *;
}

-keep public class com.google.common.collect.HashBiMap
-keepclassmembers class com.google.common.collect.HashBiMap** {
 *;
}

-keep public class javax.annotation.Nullable.** {
 public *;
}

-keep public class com.google.common.util.** {
 public *;
}

-keep public class com.google.common.primitives.** {
 public *;
}
