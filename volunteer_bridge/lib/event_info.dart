import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Event data models
class EventBasicInfo {
  String location;
  String time;
  String date;
  String organizer;

  EventBasicInfo({
    required this.location,
    required this.time,
    required this.date,
    required this.organizer,
  });
}

class EventDescription {
  String content;

  EventDescription({required this.content});
}

// Predefined tag options
class TagOption {
  final String name;
  bool isSelected;

  TagOption({required this.name, this.isSelected = false});
}

// Volunteer model
class Volunteer {
  final String name;
  
  Volunteer({required this.name});
}

// Providers
final eventBasicInfoProvider = StateProvider<EventBasicInfo>((ref) {
  return EventBasicInfo(
    location: "Location",
    time: "8:00AM - 6:00PM",
    date: "January 1, 2098",
    organizer: "Organizer Name",
  );
});

final eventDescriptionProvider = StateProvider<EventDescription>((ref) {
  return EventDescription(
    content: "Description",
  );
});

final tagOptionsProvider = StateProvider<List<TagOption>>((ref) {
  return [
    TagOption(name: "Animals", isSelected: false),
    TagOption(name: "Social Services", isSelected: true),
    TagOption(name: "Environment", isSelected: false),
    TagOption(name: "Medical Care", isSelected: false),
    TagOption(name: "Recreation and Sports", isSelected: false),
  ];
});

final volunteersProvider = StateProvider<List<Volunteer>>((ref) {
  return List.generate(12, (index) => Volunteer(name: "Person"));
});

class DonationDriveEventPage extends ConsumerStatefulWidget {
  const DonationDriveEventPage({super.key});

  @override
  _DonationDriveEventPageState createState() => _DonationDriveEventPageState();
}

class _DonationDriveEventPageState extends ConsumerState<DonationDriveEventPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Access providers
    final basicInfo = ref.watch(eventBasicInfoProvider);
    final description = ref.watch(eventDescriptionProvider);
    final tagOptions = ref.watch(tagOptionsProvider);
    final volunteers = ref.watch(volunteersProvider);
    
    // Get selected tags for display
    final selectedTags = tagOptions;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with back button only (removed time, battery and data icons)
            Container(
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
            ),
            
            // Banner Image
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/balloon.jpg'),
                fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Event Title and Participants
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "DonationDrive",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.group, color: Color(0xFFB768DE)),
                      const SizedBox(width: 5),
                      Text(
                        volunteers.length.toString().padLeft(3, '0'),
                        style: const TextStyle(
                          color: Color(0xFFB768DE),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Navigation Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTab("General Information", 0),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTab("Volunteers", 1),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Content based on selected tab
            Expanded(
              child: _selectedTabIndex == 0 
                ? _buildGeneralInfoTab(basicInfo, description, selectedTags)
                : _buildVolunteersTab(volunteers),
            ),
          ],
        ),
      ),
    );
  }
  
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
  
  Widget _buildGeneralInfoTab(EventBasicInfo basicInfo, EventDescription description, List<TagOption> tags) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information Section
            _buildSectionTitle("Basic Information", onEdit: () => _showBasicInfoEditDialog(basicInfo)),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E1F4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.location_on, basicInfo.location),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.access_time, basicInfo.time),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.calendar_today, basicInfo.date),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.favorite, basicInfo.organizer),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Description Section
            _buildSectionTitle("Description", onEdit: () => _showDescriptionEditDialog(description)),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E1F4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                description.content,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tags Section - Removed edit button
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Tags",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) => GestureDetector(
                onTap: () {
                  // Toggle tag selection directly from the main view
                  final updatedTags = [...tags];
                  final index = updatedTags.indexWhere((t) => t.name == tag.name);
                  if (index >= 0) {
                    updatedTags[index] = TagOption(
                      name: tag.name,
                      isSelected: !tag.isSelected
                    );
                    ref.read(tagOptionsProvider.notifier).state = updatedTags;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: tag.isSelected ? const Color(0xFFB768DE) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: tag.isSelected ? const Color(0xFFB768DE) : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    tag.name,
                    style: TextStyle(
                      color: tag.isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      )
    );
  }
  
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
                      volunteers[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildSectionTitle(String title, {required Function onEdit}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
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
  
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  // Popup Dialogs for Editing
  void _showBasicInfoEditDialog(EventBasicInfo currentInfo) {
    final TextEditingController locationController = TextEditingController(text: currentInfo.location);
    final TextEditingController timeController = TextEditingController(text: currentInfo.time);
    final TextEditingController dateController = TextEditingController(text: currentInfo.date);
    final TextEditingController organizerController = TextEditingController(text: currentInfo.organizer);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Edit Basic Information",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(height: 24),
              
              // Dialog Content
              SizedBox(
                height: 320, // Fixed height for scrollable content
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Location",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: locationController,
                        decoration: InputDecoration(
                          hintText: "Enter location",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      
                      const Text(
                        "Time",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: timeController,
                        decoration: InputDecoration(
                          hintText: "Enter time",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          suffixIcon: const Icon(Icons.access_time),
                        ),
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 8, minute: 0),
                          );
                          
                          if (pickedTime != null) {
                            // Format the start time
                            final startHour = pickedTime.hourOfPeriod == 0 ? 12 : pickedTime.hourOfPeriod;
                            final startMinute = pickedTime.minute.toString().padLeft(2, '0');
                            final startPeriod = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
                            
                            // Calculate end time (8 hours later)
                            final endHour = (pickedTime.hour + 8) % 24;
                            final endTimeOfDay = TimeOfDay(hour: endHour, minute: pickedTime.minute);
                            final endHourDisplay = endTimeOfDay.hourOfPeriod == 0 ? 12 : endTimeOfDay.hourOfPeriod;
                            final endMinute = endTimeOfDay.minute.toString().padLeft(2, '0');
                            final endPeriod = endTimeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
                            
                            timeController.text = "$startHour:$startMinute$startPeriod - $endHourDisplay:$endMinute$endPeriod";
                          }
                        },
                        readOnly: true, // Make it read-only to prevent keyboard input
                      ),
                      const SizedBox(height: 16),
                      
                      const Text(
                        "Date",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          hintText: "Select date",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2098, 10, 25),
                            firstDate: DateTime(2025),
                            lastDate: DateTime(2099),
                          );
                          
                          if (pickedDate != null) {
                            dateController.text = "${_getMonthName(pickedDate.month)} ${pickedDate.day}, ${pickedDate.year}";
                          }
                        },
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      
                      const Text(
                        "Organizer",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: organizerController,
                        decoration: InputDecoration(
                          hintText: "Enter organizer name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Update the state using Riverpod
                    ref.read(eventBasicInfoProvider.notifier).state = EventBasicInfo(
                      location: locationController.text,
                      time: timeController.text,
                      date: dateController.text,
                      organizer: organizerController.text,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDescriptionEditDialog(EventDescription currentDescription) {
    final TextEditingController descriptionController = TextEditingController(text: currentDescription.content);
    int wordCount = _countWords(currentDescription.content);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dialog Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Edit Description",
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  
                  // Word Count Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "$wordCount/100 words",
                        style: TextStyle(
                          color: wordCount > 100 ? Colors.red : Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Description Editor
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: "Enter event description",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                      maxLines: null,
                      expands: true,
                      onChanged: (value) {
                        setDialogState(() {
                          wordCount = _countWords(value);
                        });
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: wordCount <= 100 ? () {
                        // Update the state using Riverpod
                        ref.read(eventDescriptionProvider.notifier).state = EventDescription(
                          content: descriptionController.text,
                        );
                        Navigator.pop(context);
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  void _showTagsEditDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          // Create a local copy of tag options for editing
          List<TagOption> editableTags = ref.read(tagOptionsProvider).map((tag) => 
            TagOption(name: tag.name, isSelected: tag.isSelected)
          ).toList();
          
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dialog Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Edit Tags", 
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  
                  // Tags Selection
                  Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    children: editableTags.map((tag) => GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          tag.isSelected = !tag.isSelected;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: tag.isSelected ? const Color(0xFFB768DE) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: tag.isSelected ? const Color(0xFFB768DE) : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          tag.name,
                          style: TextStyle(
                            color: tag.isSelected ? Colors.white : Colors.black,
                            fontWeight: tag.isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Update the state using Riverpod
                        ref.read(tagOptionsProvider.notifier).state = editableTags;
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
  
  int _countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }
  
  Widget _buildParachuteGift(double size, double rotation) {
    return Transform.rotate(
      angle: rotation * 0.0174533, // Convert degrees to radians
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size / 2,
            decoration: BoxDecoration(
              color: const Color(0xFF24B6C9),
              borderRadius: BorderRadius.vertical(top: Radius.circular(size / 2)),
            ),
          ),
          ...List.generate(
            5, 
            (index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: size / 12, vertical: 1),
              child: Container(
                width: 1,
                height: size / 3,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
          Container(
            width: size / 2,
            height: size / 2,
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Container(
                width: size / 4,
                height: 2,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCloud(double size) {
    return Container(
      width: size,
      height: size / 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
  
  String _getMonthName(int month) {
    final months = [
      "", "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month];
  }
}