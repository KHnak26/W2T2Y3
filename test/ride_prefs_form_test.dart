import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:week_3_blabla_project/data/dummy_data.dart';
import 'package:week_3_blabla_project/model/ride_pref/ride_pref.dart';
import 'package:week_3_blabla_project/ui/screens/ride_pref/widgets/ride_prefs_form.dart';

void main() {
  testWidgets('Search emits RidePref when valid', (tester) async {
    final init = RidePref(
      departure: fakeLocations[0],
      arrival: fakeLocations[1],
      departureDate: DateTime.now().add(const Duration(days: 1)),
      requestedSeats: 2,
    );

    RidePref? received;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RidePrefForm(
            initRidePref: init,
            onSearch: (value) => received = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Search'));
    await tester.pump();

    expect(received, isNotNull);
    expect(received!.departure, init.departure);
    expect(received!.arrival, init.arrival);
    expect(received!.requestedSeats, init.requestedSeats);
  });

  testWidgets('Search disabled when invalid', (tester) async {
    final same = RidePref(
      departure: fakeLocations[0],
      arrival: fakeLocations[0],
      departureDate: DateTime.now().add(const Duration(days: 1)),
      requestedSeats: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RidePrefForm(initRidePref: same),
        ),
      ),
    );

    final ignorePointer = tester.widget<IgnorePointer>(find.byType(IgnorePointer));
    expect(ignorePointer.ignoring, isTrue);
  });
}
