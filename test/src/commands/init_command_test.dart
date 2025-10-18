import 'dart:io';

import 'package:flutter_makefile/src/commands/init_command.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

void main() {
  group('InitCommand', () {
    late Logger logger;
    late InitCommand initCommand;
    late Directory tempDir;

    setUp(() async {
      logger = _MockLogger();
      initCommand = InitCommand(logger: logger);

      // Create a temporary directory for testing
      tempDir = await Directory.systemTemp.createTemp('init_command_test_');

      when(() => logger.progress(any())).thenReturn(_MockProgress());
      when(() => logger.info(any())).thenReturn(null);
      when(() => logger.success(any())).thenReturn(null);
      when(() => logger.detail(any())).thenReturn(null);
      when(() => logger.warn(any())).thenReturn(null);
      when(() => logger.err(any())).thenReturn(null);
    });

    tearDown(() async {
      // Clean up temporary directory
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('can be instantiated', () {
      expect(initCommand, isNotNull);
    });

    test('has correct name', () {
      expect(initCommand.name, equals('init'));
    });

    test('has correct description', () {
      expect(
        initCommand.description,
        equals('Initialize a Flutter project with Makefile and package.json'),
      );
    });

    test('generates Makefile and package.json with default options', () async {
      // Change to temp directory for this test
      final originalDir = Directory.current;
      Directory.current = tempDir;

      try {
        final result = await initCommand.run();

        expect(result, equals(ExitCode.success.code));

        final makefilePath = path.join(tempDir.path, 'Makefile');
        final packageJsonPath = path.join(tempDir.path, 'package.json');

        final makefileFile = File(makefilePath);
        final packageJsonFile = File(packageJsonPath);

        // Check if files were created
        expect(makefileFile.existsSync(), isTrue);
        expect(packageJsonFile.existsSync(), isTrue);
      } finally {
        // Restore original directory
        Directory.current = originalDir;
      }
    });

    test('fails when Makefile already exists without force flag', () async {
      // Change to temp directory for this test
      final originalDir = Directory.current;
      Directory.current = tempDir;

      try {
        // Create a dummy Makefile
        final makefilePath = path.join(tempDir.path, 'Makefile');
        final makefileFile = File(makefilePath);
        makefileFile.writeAsStringSync('test content');

        final result = await initCommand.run();

        expect(result, equals(ExitCode.usage.code));
        verify(
          () => logger.err(
            'Makefile already exists at ./Makefile. Use --force to overwrite.',
          ),
        ).called(1);
      } finally {
        // Restore original directory
        Directory.current = originalDir;
      }
    });
  });
}
