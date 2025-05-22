import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:volunteer_bridge/ScreensOrganizer/org_create_event.dart';
import 'package:volunteer_bridge/ScreensOrganizer/org_edit_tag.dart';
import 'package:volunteer_bridge/models/event.dart';
import 'package:volunteer_bridge/models/user.dart';
import 'package:volunteer_bridge/riverpod/event_list.dart';
import 'package:volunteer_bridge/riverpod/organizer_provider.dart';
import 'package:volunteer_bridge/riverpod/volunteer_provider.dart';

/// Data model for holding general event information.
class EventInfo {
  String location;
  String time;
  String date;
  String organizer;
  String description;

  EventInfo({
    required this.location,
    required this.time,
    required this.date,
    required this.organizer,
    required this.description,
  });
}

/// Main widget for the Donation Drive Event Page.
class OrgEventInfo extends ConsumerStatefulWidget {
  final String eventId;
  const OrgEventInfo({super.key, required this.eventId});

  @override
  ConsumerState<OrgEventInfo> createState() => _OrgEventInfoPageState();
}

class _OrgEventInfoPageState extends ConsumerState<OrgEventInfo> {
  @override
  void initState() {
    super.initState();
    ref.read(eventNotifierProvider.notifier).loadEvent(widget.eventId);
  }

  int _selectedTabIndex = 0; // Used to track which tab is currently active

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(eventNotifierProvider);
    final tagOptions = ref.watch(tagOptionsProvider);

    if (event == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final volunteersAsync = ref.watch(volunteersProvider(event.id));

    return volunteersAsync.when(
        loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
        error: (e, st) => Scaffold(
              body: Center(child: Text('Error loading volunteers: $e')),
            ),
        data: (volunteers) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  _buildAppBar(), // Top app bar with back button
                  _buildBannerImage(), // Banner image section
                  _buildTitleAndParticipants(event,
                      volunteers.length), // Event title and participant count
                  _buildNavigationTabs(), // Two-tab navigation
                  const SizedBox(height: 16),
                  Expanded(
                    // Render content based on selected tab
                    child: _selectedTabIndex == 0
                        ? _buildGeneralInfoTab(event, tagOptions)
                        : _buildVolunteersTab(volunteers),
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// Builds the top app bar with back button.
  Widget _buildAppBar() {
    return Container(
      color: const Color(0xFFB768DE),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  /// Displays the top banner image for the event.
  Widget _buildBannerImage() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/balloon.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Shows the event title and number of participants.
  Widget _buildTitleAndParticipants(Event? event, int participantCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            event?.title ?? 'loading...',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.group, color: Color(0xFFB768DE)),
              const SizedBox(width: 5),
              Text(
                participantCount.toString().padLeft(3, '0'),
                style: const TextStyle(
                  color: Color(0xFFB768DE),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the tab navigation UI.
  Widget _buildNavigationTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildTab("General Information", 0)),
          const SizedBox(width: 10),
          Expanded(child: _buildTab("Volunteers", 1)),
        ],
      ),
    );
  }

  /// Builds individual tab buttons.
  Widget _buildTab(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB768DE) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFB768DE) : Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// Builds the "General Info" tab content.
  Widget _buildGeneralInfoTab(Event? event, List<TagOption> tags) {
    if (event == null) {
      return const Center(child: Text("Event not found"));
    }

    final organizerNameAsync =
        ref.watch(organizerNameProvider(event.organizerId));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Basic Information", onEdit: () async {
              _editBasicInfo(event);
            } // _editBasicInfo(info)
                ),
            _buildInfoCard([
              _buildInfoRow(Icons.location_on, event.location),
              _buildInfoRow(Icons.access_time,
                  '${DateFormat('MM/dd/yyyy').format(event.start)} -  ${DateFormat('MM/dd/yyyy').format(event.end)}'),
              _buildInfoRow(Icons.calendar_today,
                  '${event.timeStart} -  ${event.timeEnd}'),
              organizerNameAsync.when(
                data: (name) => _buildInfoRow(Icons.favorite, name),
                loading: () => _buildInfoRow(Icons.favorite, 'Loading...'),
                error: (_, __) => _buildInfoRow(Icons.favorite, 'Error'),
              ),
            ]),
            const SizedBox(height: 16),
            _buildSectionTitle("Description", onEdit: () async {
              _editDescription(event);
            } //_editDescription(info)
                ),
            _buildInfoCard([
              Text(event.description, style: const TextStyle(fontSize: 14)),
            ]),
            const SizedBox(height: 16),
            _buildSectionTitle("Tag", onEdit: () async {
              showTagPickerDialog(context, ref, event);
            }),
            displayTag(event.tag),
            //_buildTagList(tags), // Tag chips (selectable)
          ],
        ),
      ),
    );
  }

  /// Reusable card container for sections.
  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E1F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  /// Displays a non-interactive tag based on the event's tag name.
  Widget displayTag(String eventTag) {
    // Optional: Define styles or colors here
    const tagColor = Color(0xFFB768DE);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tagColor),
      ),
      child: Text(
        eventTag,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /*
  /// Toggles tag selection and updates provider state.
  void _toggleTag(TagOption tag) {
    final updatedTags = ref.read(tagOptionsProvider).map((t) {
      // If this is the selected tag, toggle it on
      if (t.name == tag.name) {
        return TagOption(name: t.name, isSelected: true);
      }
      // All others should be deselected
      return TagOption(name: t.name, isSelected: false);
    }).toList();

    ref.read(tagOptionsProvider.notifier).state = updatedTags;
  }
  */

  /// Builds the volunteers tab.
  Widget _buildVolunteersTab(List<Volunteer> volunteers) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: volunteers.length,
        itemBuilder: (context, index) {
          return _buildVolunteerCard(volunteers[index]);
        },
      ),
    );
  }

  /// Card UI for displaying a single volunteer.
  Widget _buildVolunteerCard(Volunteer volunteer) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2EAF7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: double.infinity,
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('assets/placeholder.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${volunteer.firstName} ${volunteer.lastName}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable section title with edit icon.
  Widget _buildSectionTitle(String title, {required Function onEdit}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () => onEdit(),
            child: const Icon(Icons.edit, size: 16),
          ),
        ],
      ),
    );
  }

  /// Row showing an icon and associated text.
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  /// Shows dialog to edit basic info.
  void _editBasicInfo(Event? event) {
    if (event == null) return;

    final locationController = TextEditingController(text: event.location);
    final startTimeController = TextEditingController(text: event.timeStart);
    final endTimeController = TextEditingController(text: event.timeEnd);
    final startDateController = TextEditingController(
        text: DateFormat('MM/dd/yyyy').format(event.start));
    final endDateController =
        TextEditingController(text: DateFormat('MM/dd/yyyy').format(event.end));
    //final organizerController = TextEditingController(text: event.organizer);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Basic Information"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("Location", locationController),
              _buildTextField("Start Time", startTimeController,
                  icon: Icons.access_time,
                  onTap: () =>
                      _selectTime(startTimeController, event.timeStart)),
              _buildTextField(
                "End Time",
                endTimeController,
                icon: Icons.access_time,
                onTap: () => _selectTime(endTimeController, event.timeEnd),
              ),
              _buildTextField("Start Date", startDateController,
                  icon: Icons.calendar_today,
                  onTap: () => _selectDate(startDateController)),
              _buildTextField("End Date", endDateController,
                  icon: Icons.calendar_today,
                  onTap: () => _selectDate(endDateController))

              //_buildTextField("Organizer", organizerController),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              final updated = event.copyWith(
                timeStart: startTimeController.text,
                timeEnd: endTimeController.text,
                start: parseDateTime(startDateController.text.trim()),
                end: parseDateTime(endDateController.text.trim()),
              );

              await ref
                  .read(eventNotifierProvider.notifier)
                  .updateEvent(updated);
              /*
              ref.read(eventInfoProvider.notifier).state = EventInfo(
                location: locationController.text,
                time: timeController.text,
                date: dateController.text,
                //organizer: organizerController.text,
                //description: info.description,
              );
              Navigator.pop(context);
              */
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  /// Shows dialog to edit event description.
  void _editDescription(Event? event) {
    final descriptionController =
        TextEditingController(text: event?.description ?? '');

    if (event == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Description"),
        content: TextField(
          controller: descriptionController,
          decoration:
              const InputDecoration(hintText: "Enter event description"),
          maxLines: 5,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              final updated = event.copyWith(
                  description: descriptionController.text.trim());

              await ref
                  .read(eventNotifierProvider.notifier)
                  .updateEvent(updated);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  /// Reusable form field builder.
  Widget _buildTextField(String label, TextEditingController controller,
      {IconData? icon, Function? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: icon != null ? Icon(icon) : null,
        ),
        onTap: onTap != null ? () => onTap() : null,
        readOnly: onTap != null,
      ),
    );
  }

  /// Opens a time picker dialog and updates the field.
  Future<void> _selectTime(
      TextEditingController controller, String time) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: parseTimeString(time), //TimeOfDay.now(),
    );
    if (pickedTime != null) {
      //controller.text = time.format(context);
      final String period = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
      final int hour =
          pickedTime.hourOfPeriod == 0 ? 12 : pickedTime.hourOfPeriod;
      controller.text =
          "$hour:${pickedTime.minute.toString().padLeft(2, '0')} $period";
    }
  }

  /// Opens a date picker dialog and updates the field.
  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2099),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('MM/dd/yyyy').format(pickedDate);
    }
  }
}

TimeOfDay parseTimeOfDay(String input) {
  final format = DateFormat.jm(); // e.g. "5:08 PM"
  return TimeOfDay.fromDateTime(format.parse(input));
}

TimeOfDay parseTimeString(String timeString) {
  // Handle empty or null cases
  if (timeString.isEmpty) {
    return TimeOfDay.now();
  }

  // Remove any potential whitespace
  timeString = timeString.trim();

  // Split the string to separate time and AM/PM
  List<String> parts = timeString.split(' ');
  if (parts.length != 2) {
    // Invalid format, return current time as fallback
    return TimeOfDay.now();
  }

  String time = parts[0];
  String period = parts[1].toUpperCase();

  // Split hours and minutes
  List<String> timeParts = time.split(':');
  if (timeParts.length != 2) {
    // Invalid format, return current time as fallback
    return TimeOfDay.now();
  }

  int hour = int.tryParse(timeParts[0]) ?? 0;
  int minute = int.tryParse(timeParts[1]) ?? 0;

  // Adjust hour for AM/PM
  if (period == 'PM' && hour < 12) {
    hour += 12;
  } else if (period == 'AM' && hour == 12) {
    hour = 0;
  }

  return TimeOfDay(hour: hour, minute: minute);
}
