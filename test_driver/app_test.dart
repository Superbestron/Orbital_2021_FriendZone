// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart' as test;

// Run this code from the root of the project to do integration test
// flutter drive --target=test_driver/app.dart

void main() {
  test.group('Friendzone App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final signOutButton = find.byValueKey('Sign Out Button');
    final registerGesture = find.byValueKey('Register Gesture');
    final loginButton = find.byValueKey('Sign In Button');
    final signInEmailField = find.byValueKey('Sign In Email');
    final signInPasswordField = find.byValueKey('Sign In Password');
    final bottomNavigationBar = find.byValueKey('Bottom Navigation Bar');

    late FlutterDriver driver;

    Future<bool> isPresent(SerializableFinder byValueKey,
        {Duration timeout = const Duration(seconds: 1)}) async {
      try {
        await driver.waitFor(byValueKey, timeout: timeout);
        return true;
      } catch (exception) {
        return false;
      }
    }

    // Connect to the Flutter driver before running any tests.
    test.setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    test.tearDownAll(() async {
      driver.close();
    });


    // test.test('create account', () async {
    //   await driver.tap(emailField);
    //   await driver.enterText('e0560252@u.nus.edu'); // legit email so can verify
    //
    //   await driver.tap(passwordField);
    //   await driver.enterText('12345678');
    // });

    test.test('sign in', () async {
      await driver.runUnsynchronized(() async {
        if (await isPresent(signOutButton)) {
          await driver.tap(signOutButton);
          await driver.tap(find.byValueKey('Confirm'));
        }
        await driver.tap(signInEmailField);
        await driver.enterText('tzehenn@gmail.com');

        await driver.tap(signInPasswordField);
        await driver.enterText('test1234');

        await driver.tap(loginButton);
        await driver.waitFor(find.text('Upcoming Events'));
      });
    });

    test.test('create event', () async {
      await driver.tap(bottomNavigationBar);
      await driver.tap(find.text('Create'));
      await driver.tap(find.text('Create New Event'));

      String _name = 'eventName';
      String _telegramURL = 't.me/joinchat/test';
      String _description = 'descriptionName';

      final nameField = find.byValueKey('Name');
      final date = find.byValueKey('Date');
      final time = find.byValueKey('Time');
      final descriptionField = find.byValueKey('Description');
      final telegramField = find.byValueKey('Telegram');
      final paxDropdown = find.byValueKey('Pax');
      final locationDropdown = find.byValueKey('Location');

      await driver.tap(nameField);
      await driver.enterText(_name);

      await driver.tap(date);
      await driver.tap(find.text('OK'));

      await driver.tap(time);
      await driver.tap(find.text('OK'));

      await driver.tap(descriptionField);
      await driver.enterText(_description);

      await driver.tap(telegramField);
      await driver.enterText(_telegramURL);

      await driver.tap(paxDropdown);
      await driver.tap(find.text('5'));

      await driver.tap(locationDropdown);
      await driver.tap(find.text('NUS Business School'));

      final icon = find.byValueKey('Study');
      await driver.scrollUntilVisible(find.byType('BouncingScrollPhysics'), icon);
      await driver.tap(icon);

      final addButton = find.byValueKey('floatingActionButton');
      await driver.scrollUntilVisible(find.byType('BouncingScrollPhysics'), addButton);
      await driver.tap(addButton);
      final confirmButton = find.byValueKey('confirmButton');
      await driver.tap(confirmButton);

      print('here');
      await driver.scrollUntilVisible(find.byType('AnimatedList'), find.text('eventName'));
    });
  });
}