import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;

import '../init/makefile_template.dart';
import '../init/package_json_template.dart';

/// {@template init_command}
///
/// `flutter_makefile init`
/// A [Command] to initialize a Flutter project with a Makefile
/// {@endtemplate}
class InitCommand extends Command<int> {
  /// {@macro init_command}
  InitCommand({required Logger logger}) : _logger = logger {
    argParser
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Output directory for the files',
        defaultsTo: '.',
      )
      ..addOption(
        'app-name',
        abbr: 'n',
        help: 'App name for package.json',
        defaultsTo: 'app',
      )
      ..addFlag(
        'force',
        abbr: 'f',
        help: 'Overwrite existing files if they exist',
        negatable: false,
      );
  }

  @override
  String get description =>
      'Initialize a Flutter project with Makefile and package.json';

  @override
  String get name => 'init';

  final Logger _logger;

  @override
  Future<int> run() async {
    // Check if make is installed
    await _checkMakeInstallation();

    final outputDir = argResults?['output'] as String? ?? '.';
    final appName = argResults?['app-name'] as String? ?? 'app';
    final force = argResults?['force'] as bool? ?? false;

    final makefilePath = path.join(outputDir, 'Makefile');
    final packageJsonPath = path.join(outputDir, 'package.json');

    final makefileFile = File(makefilePath);
    final packageJsonFile = File(packageJsonPath);

    // Check if files already exist
    if (!force) {
      if (makefileFile.existsSync()) {
        _logger.err(
          'Makefile already exists at $makefilePath. '
          'Use --force to overwrite.',
        );
        return ExitCode.usage.code;
      }
      if (packageJsonFile.existsSync()) {
        _logger.err(
          'package.json already exists at $packageJsonPath. '
          'Use --force to overwrite.',
        );
        return ExitCode.usage.code;
      }
    }

    try {
      // Create output directory if it doesn't exist
      final dir = Directory(outputDir);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      final progress = _logger.progress('Generating files');

      // Write the makefile template
      makefileFile.writeAsStringSync(makefileTemplate);

      // Write the package.json template with app name substitution
      final packageJsonContent = packageJsonTemplate.replaceAll(
        '{{APP_NAME}}',
        appName,
      );
      packageJsonFile.writeAsStringSync(packageJsonContent);

      await Future<void>.delayed(const Duration(milliseconds: 500));
      progress.complete('Generated Makefile and package.json');

      _logger
        ..info('')
        ..success('${lightGreen.wrap('✓')} Files created successfully!')
        ..info('')
        ..info('${styleBold.wrap('Generated files:')}')
        ..info('  ${lightCyan.wrap('✓')} Makefile')
        ..info('  ${lightCyan.wrap('✓')} package.json')
        ..info('')
        ..info('${styleBold.wrap('Next steps:')}')
        ..info(
          '  1. Install npm dependencies: ${lightCyan.wrap('make npm_install')}',
        )
        ..info('  2. Customize the configuration variables in the Makefile')
        ..info(
          '  3. Update repository URL in package.json',
        )
        ..info('  4. Run ${lightCyan.wrap('make run')} to test your app')
        ..info(
          '  5. Run ${lightCyan.wrap('make build_apk')} to build your app',
        )
        ..info('');

      return ExitCode.success.code;
    } on Exception catch (e) {
      _logger.err('Failed to create files: $e');
      return ExitCode.software.code;
    }
  }

  /// Check if make is installed on the system
  Future<void> _checkMakeInstallation() async {
    try {
      final result = await Process.run('make', ['--version']);
      if (result.exitCode == 0) {
        _logger.detail('make is installed');
        return;
      }
    } on Exception catch (_) {
      // make is not installed
    }

    // make is not installed, show warning and installation instructions
    _logger
      ..warn('')
      ..warn('${lightYellow.wrap('⚠')} make is not installed on your system')
      ..warn('')
      ..warn('${styleBold.wrap('Installation instructions:')}');

    if (Platform.isMacOS) {
      _logger
        ..warn('  macOS: Install Xcode Command Line Tools')
        ..warn('  ${lightCyan.wrap('xcode-select --install')}')
        ..warn('')
        ..warn('  Or install via Homebrew:')
        ..warn('  ${lightCyan.wrap('brew install make')}');
    } else if (Platform.isLinux) {
      _logger
        ..warn('  Ubuntu/Debian:')
        ..warn('  ${lightCyan.wrap('sudo apt-get install build-essential')}')
        ..warn('')
        ..warn('  Fedora/RHEL:')
        ..warn('  ${lightCyan.wrap('sudo dnf install make')}')
        ..warn('')
        ..warn('  Arch Linux:')
        ..warn('  ${lightCyan.wrap('sudo pacman -S make')}');
    } else if (Platform.isWindows) {
      _logger
        ..warn('  Windows: Install via Chocolatey')
        ..warn('  ${lightCyan.wrap('choco install make')}')
        ..warn('')
        ..warn('  Or install via Scoop:')
        ..warn('  ${lightCyan.wrap('scoop install make')}')
        ..warn('')
        ..warn('  Or use WSL (Windows Subsystem for Linux)');
    } else {
      _logger.warn('  Please install make using your system package manager');
    }

    _logger.warn('');
  }
}
