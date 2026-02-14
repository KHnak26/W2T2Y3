import 'package:flutter/material.dart';

import '../../../../data/dummy_data.dart';
import '../../../../model/ride/locations.dart';
import '../../../../model/ride_pref/ride_pref.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../theme/theme.dart';
import '../../../widgets/actions/bla_button.dart';
import '../../../widgets/inputs/location_picker.dart';

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

  Future<Location?> _openLocationPicker() {
    return showModalBottomSheet<Location>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const LocationPicker(),
      ),
    );
  }

  Future<void> _selectLocation(bool isDeparture) async {
    final result = await _openLocationPicker();
    if (result == null) return;
    setState(() {
      if (isDeparture) {
        departure = result;
      } else {
        arrival = result;
      }
    });
  }

  InputDecoration _decor(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: BlaColors.backgroundAccent,
      prefixIcon: Icon(icon, color: BlaColors.iconLight),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateText = departureDate == null
        ? 'Select date'
        : DateTimeUtils.formatDateTime(departureDate!);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => _selectLocation(true),
          child: InputDecorator(
            decoration: _decor('Departure', Icons.circle),
            child: Text(
              departure?.name ?? 'Search departure',
              style: BlaTextStyles.body.copyWith(color: BlaColors.textNormal),
            ),
          ),
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
        InkWell(
          onTap: () => _selectLocation(false),
          child: InputDecorator(
            decoration: _decor('Arrival', Icons.place),
            child: Text(
              arrival?.name ?? 'Search arrival',
              style: BlaTextStyles.body.copyWith(color: BlaColors.textNormal),
            ),
          ),
        ),
        const SizedBox(height: BlaSpacings.s),
        InkWell(
          onTap: _pickDate,
          child: InputDecorator(
            decoration: _decor('Date', Icons.calendar_today),
            child: Text(
              dateText,
              style: BlaTextStyles.body.copyWith(color: BlaColors.textNormal),
            ),
          ),
        ),
        const SizedBox(height: BlaSpacings.s),
        InputDecorator(
          decoration: _decor('Seats', Icons.person),
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
