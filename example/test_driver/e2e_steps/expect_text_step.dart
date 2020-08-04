import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import '../e2e.dart';

StepDefinitionGeneric ExpectTextStep() {
  return given2<String, String, E2EWorld>(
    'I expect the {string} to be {string}',
    (key, expected, context) async {
      final locator = find.byKey(Key(key));
      final data = (locator.evaluate().single.widget as Text);
      expect(data, expected);
    },
  );
}
