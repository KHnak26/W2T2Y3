import 'package:flutter/material.dart';

import '../../../model/ride/locations.dart';
import '../../../services/location_service.dart';
import '../../theme/theme.dart';

class LocationPicker extends StatefulWidget {
  final List<Location> locations;
  final String labelText;
  final ValueChanged<Location>? onSelected;

  const LocationPicker({
    super.key,
    this.locations = LocationsService.availableLocations,
    this.labelText = 'Search a city',
    this.onSelected,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onSelect = widget.onSelected ?? (Location location) {
      Navigator.of(context).maybePop(location);
    };
    final query = _controller.text.trim().toLowerCase();
    final locations = query.isEmpty
        ? widget.locations
        : widget.locations
            .where((location) => location.name.toLowerCase().contains(query))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(BlaSpacings.m),
          child: TextField(
            controller: _controller,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: widget.labelText,
              filled: true,
              fillColor: BlaColors.backgroundAccent,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: locations.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final location = locations[index];
              return ListTile(
                leading: Icon(Icons.circle, color: BlaColors.iconLight, size: 12),
                title: Text(location.name, style: BlaTextStyles.body),
                subtitle: Text(
                  location.country.name,
                  style: BlaTextStyles.label.copyWith(color: BlaColors.textLight),
                ),
                trailing: Icon(Icons.arrow_forward_ios,
                    color: BlaColors.iconLight, size: 16),
                onTap: () => onSelect(location),
              );
            },
          ),
        ),
      ],
    );
  }
}
