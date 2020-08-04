import 'dart:convert';
import 'dart:io';

import 'package:e2e/e2e.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:path_provider/path_provider.dart';

import '../lib/main.dart' as app;
import 'e2e_steps/expect_text_step.dart';
import 'e2e_steps/given_i_open_the_drawer_step.dart';
import 'e2e_steps/tap_button_n_times_step.dart';
import 'hooks/hook_example.dart';
import 'steps/colour_parameter.dart';
import 'steps/given_I_pick_a_colour_step.dart';

void main() async {
  E2EWidgetsFlutterBinding.ensureInitialized();
  testWidgets('app e2e test', (WidgetTester tester) async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');

    app.main();

    await tester.pumpAndSettle();

    final featureFiles =
        (jsonDecode(manifestJson) as Map<String, dynamic>).keys;

    final documentsDir = await getApplicationDocumentsDirectory();
    final targetFeaturesDir = Directory('${documentsDir.path}/features');
    if (targetFeaturesDir.existsSync()) {
      targetFeaturesDir.deleteSync(recursive: true);
    }

    for (var assetPath in featureFiles) {
      if (!assetPath.contains("features")) continue;
      final contents = await rootBundle.loadString(assetPath);
      final targetFile = File('${targetFeaturesDir.path}/$assetPath');
      targetFile.createSync(recursive: true);
      targetFile.writeAsStringSync(contents);
    }

    await _launch(tester, targetFeaturesDir);
  });
}

void _launch(WidgetTester tester, Directory targetFeaturesDir) async {
  final steps = [
    TapButtonNTimesStep(),
    ExpectTextStep(),
    GivenIPickAColour(),
    GivenOpenDrawer(),
  ];

  final config = TestConfiguration.DEFAULT(
    steps,
    featurePath: '${targetFeaturesDir.path}/**.feature',
  )
    ..createWorld = ((_) async => E2EWorld(tester))
    ..hooks = [
      HookExample(),
      // AttachScreenshotOnFailedStepHook(), // takes a screenshot of each step failure and attaches it to the world object
    ]
    ..customStepParameterDefinitions = [
      ColourParameter(),
    ]
    ..reporters = [StdoutReporter()]
    // ..buildFlavor = "staging" // uncomment when using build flavor and check android/ios flavor setup see android file android\app\build.gradle
    // ..targetDeviceId = "all" // uncomment to run tests on all connected devices or set specific device target id
    // ..tagExpression = '@smoke' // uncomment to see an example of running scenarios based on tag expressions
    // ..logFlutterProcessOutput = true // uncomment to see command invoked to start the flutter test app
    // ..verboseFlutterProcessLogs = true // uncomment to see the verbose output from the Flutter process
    // ..flutterBuildTimeout = Duration(minutes: 3) // uncomment to change the default period that flutter is expected to build and start the app within
    // ..runningAppProtocolEndpointUri =
    //     'http://127.0.0.1:51540/bkegoer6eH8=/' // already running app observatory / service protocol uri (with enableFlutterDriverExtension method invoked) to test against if you use this set `restartAppBetweenScenarios` to false
    ..exitAfterTestRun = true; // set to false if debugging to exit cleanly

  await GherkinRunner().execute(config);
}

class E2EWorld extends World {
  final WidgetTester tester;

  E2EWorld(this.tester);
}
