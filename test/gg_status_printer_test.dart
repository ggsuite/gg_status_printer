// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_status_printer/gg_status_printer.dart';
import 'package:test/test.dart';

void main() {
  final messages = <String>[];

  setUp(() {
    messages.clear();
  });

  // ...........................................................................
  group('GgStatusPrinter', () {
    group('run()', () {
      group('Should print running and', () {
        group('success messages', () {
          test('without carriage return', () async {
            final printer = GgStatusPrinter<String>(
              message: 'Test Operation',
              printCallback: messages.add,
              useCarriageReturn: false,
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

          test('with carriage return', () async {
            final printer = GgStatusPrinter<String>(
              message: 'Test Operation',
              printCallback: messages.add,
              useCarriageReturn: true,
            );

            await printer.run(() => Future.value('Success!'));

            expect(messages.first, equals('⌛️ Test Operation'));
            expect(
              messages.last.startsWith(GgStatusPrinter.carriageReturn),
              isTrue,
            );
          });
        });

        test('error messages', () async {
          final printer = GgStatusPrinter<String>(
            message: 'Test Operation',
            printCallback: messages.add,
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
          printCallback: messages.add,
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

    group('runSuccessTask(...)', () {
      group('with success', () {
        test('should print success status', () async {
          final printer = GgStatusPrinter<String>(
            message: 'Test Operation',
            printCallback: messages.add,
            useCarriageReturn: false,
          );

          final result = await printer.runSuccessTask(() => Future.value(true));
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
            printCallback: messages.add,
            useCarriageReturn: false,
          );

          final result =
              await printer.runSuccessTask(() => Future.value(false));
          expect(result, isFalse);
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
            printCallback: messages.add,
            useCarriageReturn: false,
          );

          await expectLater(
            printer.runSuccessTask(() => Future.error('error')),
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
  });
}
