## flutter_makefile

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
make npm_install
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

---

[coverage_badge]: coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
