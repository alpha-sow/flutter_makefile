## flutter_makefile

![version][version_badge]
![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A CLI tool to generate **Makefile** and **package.json** for Flutter projects with support for builds, testing, asset generation, and automated releases.

---

## Requirements

- Dart SDK
- `make` (the CLI will check and provide installation instructions if not found)

## Getting Started 🚀

If the CLI application is available on [pub](https://pub.dev), activate globally via:

```sh
dart pub global activate flutter_makefile
```

Or locally via:

```sh
dart pub global activate --source=path <path to this package>
```

## Usage

```sh
# Initialize a new Makefile and package.json in your Flutter project
$ flutter_makefile init

# Initialize with custom app name
$ flutter_makefile init --app-name my_awesome_app

# Initialize with custom output directory
$ flutter_makefile init --output /path/to/project

# Force overwrite existing files
$ flutter_makefile init --force

# Show CLI version
$ flutter_makefile --version

# Show usage help
$ flutter_makefile --help
```

### Init Command

The `init` command generates a comprehensive **Makefile** and **package.json** for your Flutter project. It also checks if `make` is installed on your system and provides installation instructions if needed.

**Generated Makefile includes:**
- ✅ Configurable build flavors and targets
- ✅ Support for Android (APK/AAB) and iOS (IPA) builds
- ✅ Firebase App Distribution integration
- ✅ TestFlight distribution support
- ✅ Package publishing to pub.dev
- ✅ Asset generation (icons, splash screens)
- ✅ Testing and code generation utilities
- ✅ Compatible with or without FVM

**Generated package.json includes:**
- ✅ Semantic-release configuration
- ✅ Conventional commit support
- ✅ Automated version management
- ✅ Changelog generation
- ✅ GitHub release automation

**Options:**
- `--output, -o` - Specify output directory (default: current directory)
- `--app-name, -n` - App name for package.json (default: "app")
- `--force, -f` - Overwrite existing files

**Example:**
```sh
cd my_flutter_project
flutter_makefile init --app-name my_awesome_app
make npm-install
make run
```

## Running Tests with coverage 🧪

To run all unit tests use the following command:

```sh
$ dart pub global activate coverage 1.15.0
$ dart test --coverage=coverage
$ dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov)
.

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

## Available Makefile Commands 📋

### Setup & Dependencies
- `make clean` - Clean build artifacts
- `make get` - Get Flutter dependencies
- `make pod-install` - Install iOS pods
- `make upgrade` - Upgrade Flutter dependencies

### Running
- `make run` - Run app (optionally with FLAVOR and TARGET)

### Code Generation
- `make build-runner` - Run build_runner to generate code
- `make build-runner-watch` - Watch mode for build_runner
- `make gen-assets` - Generate assets using FlutterGen

### Testing
- `make test` - Run all tests
- `make test-coverage` - Generate test coverage report

### Asset Generation
- `make icon-launcher` - Generate launcher icons
- `make splash-screen` - Generate splash screen

### Localization
- `make intl-utils` - Generate localization files
- `make purge-unused-l10n` - Remove unused localization keys

### Release Management
- `make npm-install` - Install npm dependencies
- `make release` - Create a new release
- `make release-dry` - Dry run of release

### Builds
- `make build-aab` - Build Android App Bundle
- `make build-apk` - Build Android APK
- `make build-ipa` - Build iOS IPA

### Distribution
- `make upload-apk-to-appdistrib` - Upload APK to Firebase App Distribution
- `make upload-aab-to-appdistrib` - Upload AAB to Firebase App Distribution
- `make upload-aab-to-playstore` - Upload AAB to Play Store
- `make upload-ipa-to-appdistrib` - Upload IPA to Firebase App Distribution
- `make upload-ipa-to-testflight` - Upload IPA to TestFlight

### Package Publishing
- `make deploy-dry-run` - Validate package before publishing
- `make deploy` - Publish package to pub.dev

---

[version_badge]: https://img.shields.io/badge/version-1.0.2-blue.svg
[coverage_badge]: coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
