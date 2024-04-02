// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_is_github/gg_is_github.dart';
import 'package:gg_status_printer/gg_status_printer.dart';
import 'package:test/test.dart';

void main() {
  final messages = <String>[];

  setUp(() {
    messages.clear();
    testIsGitHub = false;
  });

  tearDown(() {
    testIsGitHub = null;
  });

  // ...........................................................................
  group('GgStatusPrinter', () {
    group('run()', () {
      group('Should print running and', () {
        group('success messages', () {
          for (final carriageReturn in [null, false]) {
            test('with carriage return = $carriageReturn', () async {
              testIsGitHub = true; // No carriage return on GitHub
              final printer = GgStatusPrinter<String>(
                message: 'Test Operation',
                ggLog: messages.add,
                useCarriageReturn: carriageReturn,
              );

              final result = await printer.run(() => Future.value('Success!'));

              expect(
                messages,
                equals([
                  '⌛️ Test Operation',
                  '✅ Test Operation',
                ]),
              );
              expect(result, equals('Success!'));
            });
          }

          for (final carriageReturn in [null, true]) {
            test('with carriage return = $carriageReturn', () async {
              testIsGitHub = false; // Carriage return on local machine
              final printer = GgStatusPrinter<String>(
                message: 'Test Operation',
                ggLog: messages.add,
                useCarriageReturn: carriageReturn,
              );

              await printer.run(() => Future.value('Success!'));

              expect(messages.first, equals('⌛️ Test Operation'));
              expect(
                messages.last.startsWith(GgStatusPrinter.carriageReturn),
                isTrue,
              );
            });
          }
        });

        test('error messages', () async {
          final printer = GgStatusPrinter<String>(
            message: 'Test Operation',
            ggLog: messages.add,
            useCarriageReturn: false,
          );

          await expectLater(
            printer.run(() => Future<String>.error(Exception('Failure!'))),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'toString',
                'Exception: Failure!',
              ),
            ),
          );

          expect(
            messages,
            equals([
              '⌛️ Test Operation',
              '❌ Test Operation',
            ]),
          );
        });
      });
    });

    group('set status', () {
      test('Should print the status', () {
        final printer = GgStatusPrinter<String>(
          message: 'Test Operation',
          ggLog: messages.add,
          useCarriageReturn: false,
        );

        printer.status = GgStatusPrinterStatus.running;
        expect(messages, equals(['⌛️ Test Operation']));

        printer.status = GgStatusPrinterStatus.success;
        expect(messages, equals(['⌛️ Test Operation', '✅ Test Operation']));

        printer.status = GgStatusPrinterStatus.error;
        expect(
          messages,
          equals([
            '⌛️ Test Operation',
            '✅ Test Operation',
            '❌ Test Operation',
          ]),
        );
      });
    });

    group('logTask(...)', () {
      group('with success', () {
        test('should print success status', () async {
          final printer = GgStatusPrinter<bool>(
            message: 'Test Operation',
            ggLog: messages.add,
            useCarriageReturn: false,
          );

          final result = await printer.logTask(
            task: () => Future.value(true),
            success: (value) => value,
          );
          expect(result, isTrue);
          expect(
            messages,
            equals([
              '⌛️ Test Operation',
              '✅ Test Operation',
            ]),
          );
        });
      });

      group('with fail status', () {
        test('should print fail status', () async {
          final printer = GgStatusPrinter<String>(
            message: 'Test Operation',
            ggLog: messages.add,
            useCarriageReturn: false,
          );

          final result = await printer.logTask(
            task: () => Future.value('error'),
            success: (value) => value != 'error',
          );
          expect(result, 'error');
          expect(
            messages,
            equals([
              '⌛️ Test Operation',
              '❌ Test Operation',
            ]),
          );
        });
      });

      group('with exception', () {
        test('should print fail status', () async {
          final printer = GgStatusPrinter<String>(
            message: 'Test Operation',
            ggLog: messages.add,
            useCarriageReturn: false,
          );

          await expectLater(
            printer.logTask(
              task: () => Future.error('error'),
              success: (value) => value != 'error',
            ),
            throwsA('error'),
          );

          expect(
            messages,
            equals([
              '⌛️ Test Operation',
              '❌ Test Operation',
            ]),
          );
        });
      });
    });

    group('logStatus()', () {
      test('Should print the status', () {
        final printer = GgStatusPrinter<String>(
          message: 'Test Operation',
          ggLog: messages.add,
          useCarriageReturn: true,
        );

        const cr = GgStatusPrinter.carriageReturn;

        printer.logStatus(GgStatusPrinterStatus.running);
        expect(messages[0], '⌛️ Test Operation');

        printer.logStatus(GgStatusPrinterStatus.success);
        expect(messages[1], '$cr✅ Test Operation');

        printer.logStatus(GgStatusPrinterStatus.error);
        expect(
          messages[2],
          '$cr❌ Test Operation',
        );
      });
    });
  });
}
