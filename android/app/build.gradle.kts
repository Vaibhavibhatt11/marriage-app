plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.brahmin_marriage"
    compileSdk = 34  // Explicitly set to 34
    ndkVersion = "27.0.12077973"  // Override Flutter's NDK version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.brahmin_marriage"
        minSdk = 23  // Changed from flutter.minSdkVersion to 23
        targetSdk = 34  // Explicitly set to 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true  // Add this for Firebase
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")  // Add multidex support
}