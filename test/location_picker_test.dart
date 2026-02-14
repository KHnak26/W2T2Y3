import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:week_3_blabla_project/data/dummy_data.dart';
import 'package:week_3_blabla_project/model/ride/locations.dart';
import 'package:week_3_blabla_project/ui/widgets/inputs/location_picker.dart';

void main() {
  testWidgets('filters list when typing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationPicker(
            locations: fakeLocations,
            showBackButton: false,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'par');
    await tester.pump();

    expect(find.text('Paris'), findsOneWidget);
  });

  testWidgets('returns selected location', (tester) async {
    Location? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationPicker(
            locations: fakeLocations,
            showBackButton: false,
            onSelected: (value) => selected = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text(fakeLocations.first.name));
    await tester.pump();

    expect(selected, isNotNull);
    expect(selected!.name, fakeLocations.first.name);
  });
}
