/// The Makefile template for Flutter projects
const makefileTemplate = '''# ====================================================================================================
# Flutter Project - Makefile
# ====================================================================================================
# Makefile for Flutter project (compatible with or without FVM)
# Organized by category for easy navigation and maintenance
# ====================================================================================================

# ====================================================================================================
# CONFIGURATION
# ====================================================================================================

# App name - customize this for your project (default is Flutter's default output name)
APP_NAME ?= app

# Flutter and Dart commands - can be overridden via environment variables or command line
# Examples:
#   - Use FVM: make build_apk_release FLUTTER="fvm flutter" DART="fvm dart"
#   - Use specific path: make test FLUTTER="/path/to/flutter/bin/flutter"
#   - Use default: make test
FLUTTER ?= flutter
DART ?= dart

# Firebase App ID - pass this when uploading to Firebase App Distribution
# Example: make upload_apk_to_appdistrib FIREBASE_APP_ID="1:xxx:android:xxx"
FIREBASE_APP_ID ?=

# App Store Connect credentials - pass these when uploading to TestFlight
# Example: make upload_ipa_to_testflight APP_STORE_CONNECT_KEY_ID="ABC123" APP_STORE_CONNECT_ISSUER_ID="xxx-xxx-xxx"
APP_STORE_CONNECT_KEY_ID ?=
APP_STORE_CONNECT_ISSUER_ID ?=

# Build configuration - can be overridden via command line
# Example: make build_apk FLAVOR=staging TARGET=lib/main_staging.dart
FLAVOR ?= production
TARGET ?= lib/main.dart

# Asset generation configuration files
ICON_CONFIG ?= flutter_launcher_icons.yaml
SPLASH_CONFIG ?= flutter_native_splash.yaml

# ====================================================================================================
# SETUP & DEPENDENCIES
# ====================================================================================================

clean:
\t\$(FLUTTER) clean

get:
\t\$(FLUTTER) pub get

pod_install:
\tcd ios && arch -x86_64 pod install && cd ..

upgrade:
\t\$(FLUTTER) pub upgrade --major-versions

# ====================================================================================================
# RUNNING
# ====================================================================================================

# Run app with configurable flavor and target
# Example: make run FLAVOR=staging TARGET=lib/main_staging.dart
run:
\t\$(FLUTTER) run \\
\t\t--target=\$(TARGET) \\
\t\t--flavor \$(FLAVOR) \\
\t\t--dart-define=FLAVOR=\$(FLAVOR)

# ====================================================================================================
# CODE GENERATION
# ====================================================================================================

build_runner:
\t\$(FLUTTER) pub run build_runner build --delete-conflicting-outputs

build_runner_watch:
\t\$(FLUTTER) pub run build_runner watch --delete-conflicting-outputs

gen_assets:
\tflutterGen -c pubspec.yaml

# ====================================================================================================
# TESTING
# ====================================================================================================

test:
\t\$(FLUTTER) test

test_coverage:
\t\$(FLUTTER) test --coverage
\tlcov --remove coverage/lcov.info '*.g.dart' 'lib/*/data/*' -o coverage/lcov.cleaned.info
\tgenhtml coverage/lcov.cleaned.info -o coverage/html
\topen coverage/html/index.html

# ====================================================================================================
# ASSET GENERATION
# ====================================================================================================

# Generate launcher icons
# Example: make icon_launcher FLAVOR=staging
icon_launcher:
\t\$(DART) run flutter_launcher_icons -f \$(ICON_CONFIG)

# Generate splash screen
# Example: make splash_screen FLAVOR=staging
splash_screen:
\t\$(DART) pub run flutter_native_splash:create --path=\$(SPLASH_CONFIG)

# ====================================================================================================
# LOCALIZATION
# ====================================================================================================

intl_utils:
\t\$(FLUTTER) pub run intl_utils:generate

purge_unused_l10n:
\t./scripts/purge_unused_l10n_keys.sh

# ====================================================================================================
# RELEASE MANAGEMENT
# ====================================================================================================

npm_install:
\tnpm install

release:
\tGITHUB_TOKEN=\$(shell gh auth token) npm run release

release_dry:
\tGITHUB_TOKEN=\$(shell gh auth token) npm run release:dry

# ====================================================================================================
# ANDROID BUILD - AAB (App Bundle for Play Store)
# ====================================================================================================

# Generic AAB build with configurable flavor and target
# Example: make build_aab FLAVOR=staging TARGET=lib/main_staging.dart
build_aab:
\t\$(FLUTTER) build aab \\
\t\t--target=\$(TARGET) \\
\t\t--flavor \$(FLAVOR) \\
\t\t--dart-define=FLAVOR=\$(FLAVOR) \\
\t\t--release

# ====================================================================================================
# ANDROID BUILD - APK (Direct installation)
# ====================================================================================================

# Generic APK build with configurable flavor and target
# Example: make build_apk FLAVOR=staging TARGET=lib/main_staging.dart
build_apk:
\t\$(FLUTTER) build apk \\
\t\t--target=\$(TARGET) \\
\t\t--flavor \$(FLAVOR) \\
\t\t--dart-define=FLAVOR=\$(FLAVOR) \\
\t\t--release

# ====================================================================================================
# IOS BUILD - IPA
# ====================================================================================================

# Generic IPA build with configurable flavor and target
# Note: EXPORT_OPTIONS_PLIST can also be overridden
# Example: make build_ipa FLAVOR=staging TARGET=lib/main_staging.dart EXPORT_OPTIONS_PLIST=ios/ExportOptions-staging.plist
EXPORT_OPTIONS_PLIST ?= ios/ExportOptions.plist

build_ipa:
\t\$(FLUTTER) build ipa \\
\t\t--target=\$(TARGET) \\
\t\t--export-options-plist=\$(EXPORT_OPTIONS_PLIST) \\
\t\t--flavor \$(FLAVOR) \\
\t\t--dart-define=FLAVOR=\$(FLAVOR) \\
\t\t--release

# ====================================================================================================
# DISTRIBUTION - ANDROID
# ====================================================================================================

# Upload APK to Firebase App Distribution
upload_apk_to_appdistrib:
\tcd android && \\
\texport FIREBASE_APP_ID="\$(FIREBASE_APP_ID)" && \\
\texport ANDROID_ARTIFACT_PATH="../build/app/outputs/flutter-apk/\$(APP_NAME).apk" && \\
\tfastlane android uploadToAppDistrib

# Upload AAB to Firebase App Distribution
upload_aab_to_appdistrib:
\tcd android && \\
\texport FIREBASE_APP_ID="\$(FIREBASE_APP_ID)" && \\
\texport ANDROID_ARTIFACT_PATH="../build/app/outputs/bundle/release/\$(APP_NAME).aab" && \\
\tfastlane android uploadToAppDistrib

# Upload AAB to Play Store
upload_aab_to_playstore:
\tcd android && \\
\texport AAB_PATH="../build/app/outputs/bundle/release/\$(APP_NAME).aab" && \\
\tfastlane android uploadToPlayStore

# ====================================================================================================
# DISTRIBUTION - IOS
# ====================================================================================================

# Upload IPA to Firebase App Distribution
upload_ipa_to_appdistrib:
\tcd ios && \\
\texport FIREBASE_APP_ID="\$(FIREBASE_APP_ID)" && \\
\texport IPA_PATH="../build/ios/ipa/\$(APP_NAME).ipa" && \\
\tfastlane ios uploadToAppDistrib

# Upload IPA to TestFlight
upload_ipa_to_testflight:
\tcd ios && \\
\texport APP_STORE_CONNECT_KEY_ID="\$(APP_STORE_CONNECT_KEY_ID)" && \\
\texport APP_STORE_CONNECT_ISSUER_ID="\$(APP_STORE_CONNECT_ISSUER_ID)" && \\
\texport IPA_PATH="../build/ios/ipa/\$(APP_NAME).ipa" && \\
\tfastlane ios uploadToTestFlight
''';
