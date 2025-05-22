import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:volunteer_bridge/ScreensOrganizer/org_edit_tag.dart';
import 'package:volunteer_bridge/ScreensVolunteer/company_info.dart';
import 'package:volunteer_bridge/models/event.dart';
import 'package:volunteer_bridge/riverpod/event_list.dart';
import 'package:volunteer_bridge/riverpod/join_event_notifier.dart';
import 'package:volunteer_bridge/riverpod/organizer_provider.dart';
import 'package:volunteer_bridge/riverpod/volunteer_provider.dart';

class VolEventInfo extends ConsumerStatefulWidget {
  final String eventId;
  const VolEventInfo({super.key, required this.eventId});

  @override
  ConsumerState<VolEventInfo> createState() => _VolEventInfoPageState();
}

class _VolEventInfoPageState extends ConsumerState<VolEventInfo> {
  @override
  void initState() {
    super.initState();
    ref.read(eventNotifierProvider.notifier).loadEvent(widget.eventId);
  }

  final int _selectedTabIndex =
      0; // Used to track which tab is currently active

  @override
  Widget build(BuildContext context) {
    // Watching providers to get current state
    final event = ref.watch(eventNotifierProvider);
    final tagOptions = ref.watch(tagOptionsProvider);
    final volData = ref.watch(volunteerProvider);

    if (event == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (volData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final hasJoined = ref.watch(joinEventProvider(event.id));
    print(hasJoined);

    if (hasJoined == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final joinNotifier = ref.read(joinEventProvider(event.id).notifier);
    print(joinNotifier);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                _buildBannerImage(),
                _buildTitleAndParticipants(
                    event, event.joinedVolunteers.length),
                _buildNavigationTabs(),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildGeneralInfoTab(event, tagOptions),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: SafeArea(
              // Only wrap the button in SafeArea if needed
              child: joinButton(
                event,
                hasJoined,
                () async {
                  await joinNotifier.joinEvent();
                },
                () async {
                  await joinNotifier.leaveEvent();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget joinButton(
      Event event, bool? hasJoined, VoidCallback onJoin, VoidCallback onLeave) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: hasJoined! ? Colors.grey : Colors.green,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onPressed: hasJoined ? onLeave : onJoin,
      child: Text(
        hasJoined ? 'Event Joined' : 'Join Event',
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
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
        ],
      ),
    );
  }

  /// Builds individual tab buttons.
  Widget _buildTab(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            _buildSectionTitle("Basic Information"),
            _buildInfoCard([
              _buildInfoRow(Icons.location_on, event.location, false),
              _buildInfoRow(
                  Icons.access_time,
                  '${DateFormat('MM/dd/yyyy').format(event.start)} -  ${DateFormat('MM/dd/yyyy').format(event.end)}',
                  false),
              _buildInfoRow(Icons.calendar_today,
                  '${event.timeStart} -  ${event.timeEnd}', false),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AboutUsPage(orgId: event.organizerId))),
                child: organizerNameAsync.when(
                  data: (name) => _buildInfoRow(Icons.favorite, name, true),
                  loading: () =>
                      _buildInfoRow(Icons.favorite, 'Loading...', false),
                  error: (_, __) =>
                      _buildInfoRow(Icons.favorite, 'Error', false),
                ),
              )
            ]),
            const SizedBox(height: 16),
            _buildSectionTitle("Description"),
            _buildInfoCard([
              Text(event.description, style: const TextStyle(fontSize: 14)),
            ]),
            const SizedBox(height: 16),
            _buildSectionTitle("Tag"),
            displayTag(event.tag),
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

  /// Shows tags.
  Widget displayTag(String eventTag) {
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

  /// Reusable section title with edit icon.
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Row showing an icon and associated text.
  Widget _buildInfoRow(IconData icon, String text, bool? navigation) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 14,
                decoration: navigation == true
                    ? TextDecoration.underline
                    : TextDecoration.none,
                color: navigation == true ? Colors.blue : Colors.black),
          ),
        ),
      ],
    );
  }
}
