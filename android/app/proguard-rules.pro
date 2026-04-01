# Flutter specific rules
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Hive
-keep class * extends com.google.flatbuffers.Table { *; }
-keep class * implements com.hive.annotations.HiveType { *; }

# Keep model classes
-keep class com.aurix.stock.** { *; }

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
