# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# M7 Livelyness Detection Plugin
-keep class com.example.m7_livelyness_detection.** { *; }

# Google ML Kit
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.** { *; }

# Camera plugins
-keep class io.flutter.plugins.camera.** { *; }
-keep class com.apparence.camerawesome.** { *; }

# Google Play Core (for split compatibility)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Optimize native code size
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification
-dontpreverify

# Reduce method count for native dependencies
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose

# Additional keep rules for missing classes
-dontwarn com.google.android.play.core.**