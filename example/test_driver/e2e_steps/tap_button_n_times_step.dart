import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import '../e2e.dart';

StepDefinitionGeneric TapButtonNTimesStep() {
  return given2<String, int, E2EWorld>(
    'I tap the {string} button {int} times',
    (key, count, context) async {
      final locator = find.byKey(Key(key));
      for (var i = 0; i < count; i += 1) {
        await context.world.tester.tap(locator);
      }
    },
  );
}
