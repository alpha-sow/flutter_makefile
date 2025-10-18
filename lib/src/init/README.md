# Init Templates

This directory contains templates used by the `flutter_makefile init` command.

## Files

- **makefile_template.dart** - Contains the Makefile template for Flutter projects
- **package_json_template.dart** - Contains the package.json template for semantic-release

## Usage

When a user runs:

```bash
flutter_makefile init --app-name my_app
```

The `InitCommand` will:
1. Read the `makefileTemplate` from `makefile_template.dart`
2. Read the `packageJsonTemplate` from `package_json_template.dart`
3. Write both files to the user's current directory (or specified output directory)
4. Replace `{{APP_NAME}}` placeholder in package.json with the actual app name
5. Display success message and next steps

## Templates

### Makefile Template

Contains a comprehensive Makefile with:
- Build commands for Android (APK/AAB) and iOS (IPA)
- Asset generation (icons, splash screens)
- Testing and code generation utilities
- Distribution commands (Firebase, TestFlight, Play Store)
- Configurable flavors and targets
- FVM compatibility
- Release management with semantic-release

### Package.json Template

Contains semantic-release configuration for:
- Automated version management based on conventional commits
- Changelog generation
- GitHub release creation
- Git tagging
- Support for main/master and develop branches
- Configurable commit types (feat, fix, perf, refactor, etc.)

#### Conventional Commits

The package.json is configured to use conventional commits:
- `feat:` - New features (minor version bump)
- `fix:` - Bug fixes (patch version bump)
- `perf:` - Performance improvements (patch version bump)
- `refactor:` - Code refactoring (patch version bump)
- `BREAKING CHANGE:` - Breaking changes (major version bump)

## Customization

### Updating Makefile Template

1. Edit the `makefileTemplate` constant in `makefile_template.dart`
2. Ensure proper escaping of special characters
3. Use `\t` for tab indentation (required by Makefiles)
4. Test the generated Makefile works correctly

### Updating Package.json Template

1. Edit the `packageJsonTemplate` constant in `package_json_template.dart`
2. Use `{{APP_NAME}}` as a placeholder for the app name
3. Test the generated package.json is valid JSON
4. Ensure semantic-release plugins are configured correctly
5. Verify all npm package versions are up-to-date
