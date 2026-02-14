import 'package:flutter/material.dart';

import '../../../../data/dummy_data.dart';
import '../../../../model/ride/locations.dart';
import '../../../../model/ride_pref/ride_pref.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../theme/theme.dart';
import '../../../widgets/actions/bla_button.dart';

class RidePrefForm extends StatefulWidget {
  final RidePref? initRidePref;
  final ValueChanged<RidePref>? onSearch;

  const RidePrefForm({super.key, this.initRidePref, this.onSearch});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  DateTime? departureDate;
  Location? arrival;
  int requestedSeats = 1;

  @override
  void initState() {
    super.initState();
    departure = fakeLocations.isNotEmpty ? fakeLocations.first : null;
    arrival = fakeLocations.length > 1 ? fakeLocations[1] : departure;
    departureDate = DateTime.now().add(const Duration(days: 1));
    requestedSeats = 1;

    final init = widget.initRidePref;
    if (init != null) {
      departure = init.departure;
      arrival = init.arrival;
      departureDate = init.departureDate;
      requestedSeats = init.requestedSeats;
    }
  }

  void _swapLocations() {
    if (departure == null || arrival == null) return;
    setState(() {
      final tmp = departure;
      departure = arrival;
      arrival = tmp;
    });
  }

  Future<void> _pickDate() async {
    final initialDate = departureDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      departureDate = picked;
    });
  }

  void _onSearch() {
    if (departure == null || arrival == null || departureDate == null) return;
    final ridePref = RidePref(
      departure: departure!,
      arrival: arrival!,
      departureDate: departureDate!,
      requestedSeats: requestedSeats,
    );
    if (widget.onSearch != null) {
      widget.onSearch!(ridePref);
    } else {
      Navigator.of(context).maybePop(ridePref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationItems = fakeLocations
        .map(
          (location) => DropdownMenuItem<Location>(
            value: location,
            child: Text('${location.name}, ${location.country.name}'),
          ),
        )
        .toList();

    final dateText = departureDate == null
        ? 'Select date'
        : DateTimeUtils.formatDateTime(departureDate!);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<Location>(
          value: departure,
          decoration: InputDecoration(
            labelText: 'Departure',
            filled: true,
            fillColor: BlaColors.backgroundAccent,
            prefixIcon: Icon(Icons.circle, color: BlaColors.iconLight),
          ),
          iconEnabledColor: BlaColors.iconLight,
          items: locationItems,
          onChanged: (value) => setState(() => departure = value),
        ),
        const SizedBox(height: BlaSpacings.s),
        Center(
          child: IconButton(
            onPressed: _swapLocations,
            icon: const Icon(Icons.swap_vert),
            color: BlaColors.iconLight,
          ),
        ),
        const SizedBox(height: BlaSpacings.s),
        DropdownButtonFormField<Location>(
          value: arrival,
          decoration: InputDecoration(
            labelText: 'Arrival',
            filled: true,
            fillColor: BlaColors.backgroundAccent,
            prefixIcon: Icon(Icons.place, color: BlaColors.iconLight),
          ),
          iconEnabledColor: BlaColors.iconLight,
          items: locationItems,
          onChanged: (value) => setState(() => arrival = value),
        ),
        const SizedBox(height: BlaSpacings.s),
        InkWell(
          onTap: _pickDate,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Date',
              filled: true,
              fillColor: BlaColors.backgroundAccent,
              prefixIcon: Icon(Icons.calendar_today, color: BlaColors.iconLight),
            ),
            child: Text(
              dateText,
              style: BlaTextStyles.body.copyWith(color: BlaColors.textNormal),
            ),
          ),
        ),
        const SizedBox(height: BlaSpacings.s),
        InputDecorator(
          decoration: InputDecoration(
            labelText: 'Seats',
            filled: true,
            fillColor: BlaColors.backgroundAccent,
            prefixIcon: Icon(Icons.person, color: BlaColors.iconLight),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: requestedSeats > 1
                    ? () => setState(() => requestedSeats--)
                    : null,
                icon: const Icon(Icons.remove),
                color: BlaColors.iconNormal,
              ),
              Text('$requestedSeats', style: BlaTextStyles.body),
              IconButton(
                onPressed: requestedSeats < 8
                    ? () => setState(() => requestedSeats++)
                    : null,
                icon: const Icon(Icons.add),
                color: BlaColors.iconNormal,
              ),
            ],
          ),
        ),
        const SizedBox(height: BlaSpacings.m),
        BlaButton(
          text: 'Search',
          onPressed: _onSearch,
        ),
      ],
    );
  }
}
