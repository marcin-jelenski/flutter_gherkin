import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import '../e2e.dart';

/// Opens the applications main drawer
///
/// Examples:
///
///   `Given I open the drawer`
StepDefinitionGeneric GivenOpenDrawer() {
  return given1<String, E2EWorld>(
    RegExp(r'I (open|close) the drawer'),
    (action, context) async {
      final drawerFinder = find.byType(Drawer);
      // https://github.com/flutter/flutter/issues/9002#issuecomment-293660833
      if (action == 'close') {
        // Swipe to the left across the whole app to close the drawer
        await context.world.tester.dragFrom(
            Offset(300, 0), context.world.tester.getTopLeft(drawerFinder));
      } else if (action == 'open') {
        await context.world.tester.tap(find.byTooltip('Open navigation menu'));
      }
    },
  );
}
