# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
-keep public class androidx.appcompat.widget.* { *; }
-keep class androidx.appcompat.widget.SearchView { *; }

# for com.squareup.okhttp3:logging-interceptor.
-dontwarn okio.**
-dontwarn rx.**
-dontwarn com.squareup.okhttp3.*

# for com.squareup.retrofit2:retrofit.
-dontwarn retrofit2.**
-dontwarn com.google.common.base.**
-keep class com.google.common.base.* {*;}
-dontwarn com.google.errorprone.annotations.**
-keep class com.google.errorprone.annotations.* {*;}
-dontwarn com.google.****
-keep class com.google.* {*;}
-keepattributes *Annotation*
# for org.greenrobot:eventbus.
-keepclassmembers class * {
    @org.greenrobot.eventbus.Subscribe <methods>;
}
-keep enum org.greenrobot.eventbus.ThreadMode { *; }

# Only required if you use AsyncExecutor
-keepclassmembers class * extends org.greenrobot.eventbus.util.ThrowableFailureEvent {
    <init>(java.lang.Throwable);
}

#com.github.bumptech.glide:glide
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public class * extends com.bumptech.glide.module.AppGlideModule
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}
-keep class com.crashlytics.* { *; }
-dontwarn com.crashlytics.**
-keep class com.shockwave.*
-keepclassmembers class * {    @android.webkit.JavascriptInterface <methods>;}
-keepattributes JavascriptInterface
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.* {*;}
-optimizations !method/inlining/*
-keepclasseswithmembers class * {  public void onPayment*(...);}

-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

-keep class com.amazonaws.** { *; }

-keep class org.apache.commons.logging.**               { *; }
-keep class com.amazonaws.services.sqs.QueueUrlHandler  { *; }
-keep class com.amazonaws.javax.xml.transform.sax.*     { public *; }
-keep class com.amazonaws.javax.xml.stream.**           { *; }
-keep class com.amazonaws.services.**.model.*Exception* { *; }
-keep class org.codehaus.**                             { *; }
-keepattributes Signature,*Annotation*

-dontwarn javax.xml.stream.events.**
-dontwarn org.codehaus.jackson.**
-dontwarn org.apache.commons.logging.impl.**
-dontwarn org.apache.http.conn.scheme.**