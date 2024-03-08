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
              operation: Future.value('Success!'),
              printCallback: messages.add,
              useCarriageReturn: false,
            );

            final result = await printer.run();

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
              operation: Future.value('Success!'),
              printCallback: messages.add,
              useCarriageReturn: true,
            );

            await printer.run();

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
            operation: Future<String>.error(Exception('Failure!')),
            printCallback: messages.add,
            useCarriageReturn: false,
          );

          await expectLater(
            printer.run(),
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
  });
}
